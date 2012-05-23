class User < ActiveRecord::Base
  #STATUSES
  #1 = active
  #0 = not confirm
  #2 = suspended

  has_many :socials
  has_many :alerts, :as => :sender, :dependent => :destroy
  has_many :authentications
  #has_many   :logins, :dependent => :destroy
  belongs_to :address
  belongs_to :section
  belongs_to :city
  has_many :favorites, :dependent => :destroy
  has_many :places, :dependent => :destroy
  has_many :assets, :as => :uploadable, :dependent => :destroy
  has_many :listings, :dependent => :destroy
  has_many :suspended_accounts
  has_many :announcements, :dependent => :destroy
  has_many :shouts, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :confirmations, :as => :confirmable, :dependent => :destroy

  validates_presence_of :email, :message => "Email address should not be blank"
  validates_presence_of :password
  validates_uniqueness_of :email, :if => :email_changed?
  validates_uniqueness_of :username, :if => :username_changed?
  validates_confirmation_of :password, :if => :password_changed?
  serialize :settings
  serialize :facebook_information

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#", :super_thumb => "50x50#" },
                    :url => "/system/uploads/:class/:attachment/:id/:basename_:style.:extension",
                    :default_url => "/images/missing.png"

  validates_attachment_size :avatar, :less_than => 4.megabyte
  validates_attachment_content_type :avatar, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )

  has_many :events, :dependent => :destroy
  has_many :deals, :dependent => :destroy
  has_many :histories, :dependent => :destroy  do
    def uniq_recent
      ret = []
      grp = order("updated_at DESC").group_by(&:listing_id)

      grp.keys.each do |k|
        ret <<  grp[k].first
      end
      ret
    end
  end

  cattr_reader :per_page
  self.per_page = 5
  scope :admins, where("user_type IN ('administrator', 'normal_admin', 'normal', 'sales')")
  scope :regular_users, where("user_type='regular'")
  scope :advertisers, where("user_type='advertiser'").order("created_at DESC")


  has_many :payments, :dependent => :destroy do
    def payments_paginated(page)
      paginate :page => page
    end
  end
  
  has_many :messages, :as => :viewer, :dependent => :destroy do
    def unread
      find( :all,
            :conditions => "is_viewed=0 AND msgtype='inbox'",
            :order => "created_at DESC" )
    end

    def get_messages(page=nil)
      result = where("msgtype='inbox'").order("created_at DESC")
      grp = result.group_by(&:message_thread_id)
      messages = []

      grp.keys.each do |k|
        messages << grp[k].first
      end

      unless page.nil?
        start = (page.to_i * Constant::MESSAGE_PER_PAGE) - Constant::MESSAGE_PER_PAGE
        finish = (page.to_i * Constant::MESSAGE_PER_PAGE) - 1
        messages[start..finish]
      else
        messages
      end
    end
  end

  class << self
    def all_users(type=nil)

      unless type.nil?
        User.where("user_type=?", type)
      else
        User.all
      end
    end
    
    def get_administrators(page)
      User.admins.paginate :page => page, :per_page => 10
    end

    def is_unique?(str, type = 'email')
      if type.to_s == "email"
        u = User.find_by_email(str)
      else
        u = User.find_by_username(str)
      end
      u.nil?
    end

    def get_users(type, params = {})
      order_by = params[:order_by] || "created_at"
      page = params[:page] rescue nil
      paginate :page => page,
               :conditions => ["user_type=?", type],
               :order => "#{order_by} DESC"
    end
  end

  def first_login?
    logins = Login.where("username=?", self.email)
    return true if logins.length < 2
    return false
  end

  def self.find_activated_user(email, password)
    password_hash = Helper.encrypt_password(password)
    User.find(:first, :conditions => ["email = ? AND password = ?", email, password_hash])
  end

  def self.find_activated_id(id)
    User.find(:first, :conditions => ["status=1 AND id=?", id])
  end

  def self.create_update(params)
    user = User.find_by_email(params[:email]) || User.new
    user.email  = params[:email]
    user.username  = params[:username]
    user.password  = Helper.encrypt_password(params[:password])
    user.user_type = params[:user_type] unless params[:user_type].nil?
    user.status    = params[:status] unless params[:status].nil?
    user.dob       = params[:dob] unless params[:dob].nil?
    user.gender    = params[:gender] unless params[:gender].nil?
    user.company_name            = params[:company_name] unless params[:company_name].nil?
    user.company_name_registered = params[:company_name_registered] unless params[:company_name_registered].nil?
    user.company_reg_number      = params[:company_reg_number] unless params[:company_reg_number].nil?
    user.firstname  = params[:firstname] unless params[:firstname].nil?
    user.lastname   = params[:lastname] unless params[:lastname].nil?
    user.middlename = params[:middlename] unless params[:middlename].nil?
    user.advert_company_name      = params[:advert_company_name] unless params[:advert_company_name].nil?
    user.advert_company_name_registered = params[:advert_company_name_registered] unless params[:advert_company_name_registered].nil?
    user.advert_company_reg_number      = params[:advert_company_reg_number] unless params[:advert_company_reg_number].nil?
    user.steps = params[:steps] unless params[:steps].nil?
    user.settings = params[:settings] unless params[:settings].nil?
    user.save!
    user
  end

  def fullname
    fullname = self.firstname.titleize rescue ''
    fullname += " #{(self.lastname.titleize rescue '')}"
  end

  def name_or_email
    if self.is_advertiser?
      return self.advert_company_name
    end

    unless self.fullname.blank?
      return self.fullname if self.fullname.strip.blank?
    end
    
    return self.username unless self.username.nil?
    return self.email
  end

  def super_admin?
    (self.email == "admin")
  end

  def is_master_admin?
    (self.user_type == "administrator")
  end

  def is_admin?
    (self.user_type == "administrator" || self.user_type == "normal_admin")
  end

  def is_normal_admin?
    (self.user_type == "normal_admin")
  end

  def is_advertiser?
    (self.user_type == "advertiser")
  end

  def is_regular?
    (self.user_type == "regular")
  end

  def is_active?
    (self.status)
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    
    case omniauth['provider']
    when 'facebook'
      self.apply_facebook(omniauth)
    end

    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => (omniauth['credentials']['token'] rescue nil))
          
  end
  
  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end

#  def password=(pass)
#    @password = Helper.encrypt_password(pass)
#    @password_confirmation = Helper.encrypt_password(pass)
#  end
#  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def self.create_with_omniauth(auth)
    user = User.find_by_email(auth["info"]["email"])  || User.new

    if user.new_record?
      user.user_type = "regular"
    end

    if user.user_type == "regular"
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = auth["info"]["email"]
      user.firstname = auth["info"]["first_name"] if user.firstname.nil?
      user.lastname = auth["info"]["last_name"] if user.lastname.nil?
      user.image_facebook = auth["info"]["image"]
      user.facebook_information = auth
      user.steps = "complete"
      user.password = Helper.encrypt_password(Helper.generate_password)
      user.status = 1
      user.username = auth['extra']['raw_info']["username"] rescue ''
      user.gender = auth['extra']['raw_info']["gender"] rescue ''
      user.save!
    end

    user
  end

  def latest_updates(unread_only=true, limit=nil)
    places = []
    self.favorites.each{ |fav| places << fav.likeable.listable.place rescue nil }
    places.compact!
    place_ids = places.map(&:id)
    return [] if place_ids.empty?
    updates = ListingUpdate.where("shown = 1 AND place_id IN (#{place_ids.join(',')}) AND DATE_FORMAT(created_at,'%Y-%m-%d')  > ?", 30.days.ago.to_date)
              .order("created_at DESC")

    if unread_only.class == TrueClass
      li_ids = updates.map(&:id)
      #get those you have read
      have_read = Readable.where("reader_id=? AND reader_type='User' AND readable_type='ListingUpdate' AND readable_id IN (?)", self.id, li_ids)
      have_read_ids = have_read.map(&:readable_id)
      result = updates.select {|lu| !have_read_ids.include?(lu.id)}
      ret = result
    elsif unread_only.class == FalseClass
      ret = updates
    else
      li_ids = updates.map(&:id)
      #get those you have read
      have_read = Readable.where("reader_id=? AND reader_type='User' AND readable_type='ListingUpdate' AND readable_id IN (?)", self.id, li_ids)
      have_read_ids = have_read.map(&:readable_id)
      result = updates.select {|lu| have_read_ids.include?(lu.id)}
      ret = result
    end

    return ret.take(limit) unless limit.nil?
    return ret
  end

  def sender_name
    return self.fullname unless fullname.blank?
    return self.email
  end

  def notify_updates_perday?
    return false if self.settings.nil?
    unless self.settings["notify_updates"].nil?
      return true if self.settings["notify_updates"] == "perday"
    end
    false
  end

  def notify_updates_everytime?
    return true if self.settings.nil?
    unless self.settings["notify_updates"].nil?
      return true if self.settings["notify_updates"] == "everytime"
    end
    false
  end

  def notify_message_everytime?
    return true if self.settings.nil?
    unless self.settings["notify_message"].nil?
      return true if self.settings["notify_message"] == "everytime"
    end
    false
  end

  def has_payment_recently?
    unless self.payments.empty?
      self.payments.last.created_at.to_date  == Time.now.to_date
    else
      false
    end
  end

  def is_freeaccount?
    package = self.payments.last.package rescue nil

    unless package.nil?
      return false if package.package_code != "free"
    end
    return true
  end

  def premium_subscriber?
    package = self.payments.last.package rescue nil

    unless package.nil?
      return true if package.package_code.include?("premium")
    end
    return false
  end

  def recent_package_subscribed
    self.payments.last.package rescue nil
  end

  def has_this_favorite?(listing)
    found = Favorite.find(:first, :conditions => ["likeable_id = ? AND likeable_type = ? AND user_id = ?", listing.id, listing.class.name, self.id]) rescue nil
    !found.nil?
  end

  def latest_subscription
    res = self.payments.last rescue nil
    unless res.nil?
      return res.package
    end
    nil
  end
  
  #this counts events and deals since we are merging the counters
  def remaining_events
    return 0 if self.recent_package_subscribed.nil?
    posts = []
    posts += self.deals
    posts += self.events
    return self.recent_package_subscribed.allowed_events - posts.length
  end
  
  def remaining_deals
    return 0 if self.recent_package_subscribed.nil?
    return self.recent_package_subscribed.allowed_deals - self.deals.length
  end

  def remaining_images(deal_event)
    return 0 if self.recent_package_subscribed.nil?
    return (self.recent_package_subscribed.allowed_images - deal_event.pictures.length)
  end

  def place_remaining_images
    return 0 if self.recent_package_subscribed.nil?
    return self.recent_package_subscribed.allowed_images - self.places.first.pictures.length
  end
  
  def remaining_announcements
    return 0 if self.recent_package_subscribed.nil?
    return self.recent_package_subscribed.allowed_announcements
  end  
  
  def last_payment
    res = self.payments.last rescue nil
    return res unless res.nil?
    nil
  end
  
  def partial_address
    html = ""
    html = "#{self.section.name}" unless self.section.nil?
    html += ", #{self.city.name}" unless self.city.nil?
  end
  
  def suspended?
    (self.status == 2)
  end
  
  def has_callbacks?
    alerts = self.alerts.where("alert_type='call'")
    return true if alerts.length > 0
    false
  end

  def has_overdue?
    unless self.last_payment.nil?
      if Time.now > self.last_payment.contract_end
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def place
    self.places.first rescue nil
  end

  def has_social(provider)
    self.socials.where("provider=?", provider).first || nil
  end
  
end
