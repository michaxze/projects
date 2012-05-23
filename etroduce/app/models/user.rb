class User < ActiveRecord::Base

  has_one :subscription
  has_many :opportunities, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :invitations, :dependent => :destroy
  has_many :contact_lists, :dependent => :destroy
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :super_thumb => "50x50" }
  validates_attachment_content_type :avatar, :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/x-ms-bmp image/x-xbitmap image/x-xpixmap image/ief image/tiff image/bmp image/ief image/pipeg )

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_uniqueness_of :email, :username
  validates_presence_of :email
  validates_confirmation_of :password

  class << self

    def create_with_omniauth(auth)
      case auth["provider"]
      when "facebook"
        create! do |user|
          user.provider       = auth["provider"]
          user.uid            = auth["uid"]
          user.firstname      = auth["user_info"]["first_name"]
          user.lastname       = auth["user_info"]["lastname"]
          user.email          = auth["user_info"]["email"]
          user.image_facebook = auth["user_info"]["image"]
          user.gender         = auth["user_info"]["gender"]
          user.timezone       = auth["user_info"]["timezone"]
        end
      when "twitter"
        #TODO
      end
    end
    
    def exists?(email, user=nil)
      unless user.nil?
        found = User.find(:all, :conditions => ["email = ? AND id != ?", email.to_s, user.id])
      else
        found = User.find(:all, :conditions => ["email = ?", email.to_s])
      end

      (found.length > 0)
    end
    
    def username_unique?(username, user=nil)
      return 1 if Constant::RESERVED_USERNAMES.include?(username)
      
      unless user.nil?
        found = User.find(:all, :conditions => ["username = ? AND id != ?", username.to_s, user.id])
      else
        found = User.find(:all, :conditions => ["username = ?", username.to_s])
      end
      (found.length > 0)
    end

    def password_valid?(password, cpassword)
      if password.blank? and cpassword.blank?
        false
      elsif password != cpassword
        false
      else
        true
      end
    end

    def find_email_password(email, password)
      find(:first, :conditions => ["email = ? AND password = ?", email, password])
    end

    def create_user(params)
      user = User.new
      user.password = Helper.encrypt_password(params[:password], params[:email])
      user.firstname = params[:firstname] unless params[:firstname].nil?
      user.lastname  = params[:lastname] unless params[:lastname].nil?
      user.email     = params[:email] unless params[:email].nil?
      user.zipcode   = params[:zipcode] unless params[:zipcode].nil?
      user.username  = params[:username] unless params[:username].nil?
      user.registration_token = Helper::generate_token
      user.save!
      user
    end
    
    def add_invitation_to_contact(who_invited, invited_user)
      Contact.add_contact(who_invited, invited_user)
      Contact.add_contact(invited_user, who_invited)
    end

  end



  def friends(limit=nil)
    contact_ids = self.contacts.map(&:contact_user_id)
    User.find(:all, :conditions => ["id IN (?)", contact_ids], :limit => limit)
  end
  
  def update_user(params)
    self.firstname = params[:firstname] unless params[:firstname].nil?
    self.lastname  = params[:lastname] unless params[:lastname].nil?
    self.zipcode   = params[:zipcode] unless params[:zipcode].nil?
    self.username  = params[:username] unless params[:username].nil?
    self.email     = params[:email] unless params[:email].nil?
    self.expertise = params[:expertise] unless params[:expertise].nil?
    self.mobileno  = params[:mobileno] unless params[:mobileno].nil?
    self.avatar    = params[:avatar] unless params[:avatar].nil?
    self.password  = Helper.encrypt_password(params[:password], self.email) unless params[:password].nil?
    self.save
    self
  end
  
  def contact_users
    user_ids = self.contacts.map(&:contact_user_id)
    users = User.find(:all, :conditions => ["id IN (?)", user_ids])
  end

  def friends_of_friends
    contacts = self.contacts
    contact_ids = contacts.map(&:id)

    friend_ids = []
    self.contacts.each do |c|
      unless c.user.nil?
        friend_ids += c.user.contacts.map(&:contact_user_id)
      end
    end

    friend_ids.compact!
    friend_ids.uniq!
    friends = User.find(:all, :conditions => ["id IN (?) AND id <> ?", friend_ids, self.id])
  end

  def create_update(params)
    if self.new_record?
      params[:password] = Helper.encrypt_password(params[:password], params[:email])
      params[:password_confirmation] = params[:confirm_password]
    end
    self.firstname = params[:firstname] unless params[:firstname].nil?
    self.lastname  = params[:lastname] unless params[:lastname].nil?
    self.email     = params[:email] unless params[:email].nil?
    self.save!
  end

  def reset_password
    self.update_attribute(:password, Helper.encrypt_password(Helper::DEFAULT_PASSWORD, self.email))
  end

  def change_password(params)
    params[:password]              = Helper.encrypt_password(params[:password], self.email)
    params[:password_confirmation] = Helper.encrypt_password(params[:password_confirmation], self.email)
    self.attributes = params
    self.save!
  end

  def fullname
     "#{self.firstname} #{self.lastname}"
  end
  
  def not_confirmed?
    self.verified_identity_at.nil?
  end
  
  def update_facebook_information(auth)
    self.uid = auth["uid"]
    self.provider = auth["provider"]
    self.image_facebook = auth["user_info"]["image"]
    self.gender = auth["user_info"]["gender"]
    self.timezone = auth["user_info"]["timezone"]    
    self.save
  end
  
  def not_friends_with?(user)
    c = Contact.find(:first, :conditions => ["user_id = ? AND contact_user_id = ?", self.id, user.id]) rescue nil
    c.nil?
  end
  
  def has_valid_subscription?
    puts self.subscription.inspect
    !(self.subscription && Time.now.to_date > self.subscription.end_date.to_date)
  end

end
