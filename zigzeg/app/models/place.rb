class Place < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
 # belongs_to :address
  belongs_to :category

  has_many :products, :dependent => :destroy
  has_many :services, :dependent => :destroy
  has_many :brands, :dependent => :destroy
  has_many :deals, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :assets, :as => :uploadable, :dependent => :destroy
  has_many :announcements, :as => :announceable, :dependent => :destroy
  has_many :highlights, :as => :highlightable, :dependent => :destroy
  has_many :ratings, :as => :rateable
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_one :address_extension, :as => :addressable, :dependent => :destroy
  has_one :address, :as => :addressable, :dependent => :destroy
  has_many :shouts, :as => :shoutable, :dependent => :destroy
  has_many :listing_updates, :as => :updateable, :dependent => :destroy

  serialize :operation_times
  serialize :category_features

  validates_presence_of :user_id, :name

  after_update :update_listing_data
  after_save :update_published

  cattr_reader :per_page
  self.per_page = 20
  class << self
    def search_tag(tags, params = {})
      places = ret = []
      new_list = []
      places_tags = []
      tags_array = []
      tags_array = tags.split(",")
      tags_array.collect!{|t| t.strip }


      tags_array.each do |t|
        unless params[:scat].nil?
          if params[:scat].to_i > 0
            places += where("category_id = ? AND tags like ?", params[:scat].to_i, "%#{t.strip}%").order("created_at DESC")
          end
        end

        # if no tags found on sub category places
        if places.empty?
          logger.info("Searching other sub categories...")
          unless params[:cat].nil?
            if params[:cat].to_i > 0
              cat = Category.find(params[:cat].to_i)
              subcat_ids = cat.subcategories.map(&:id)
              subcat_ids << cat.id
              places += where("category_id IN (?) AND tags like ?", subcat_ids, "%#{t.strip}%").order("created_at DESC")
            end
          end
        end

        if places.empty?
          logger.info("Searching other categories..")
          unless params[:cat].nil?
            if params[:cat].to_i > 0
              cat = Category.find(params[:cat].to_i)
              places += where("tags like ?",  "%#{t.strip}%").order("created_at DESC")
            end
          end
        end

      end

      unless places.empty?
        places.each do |p|
          unless p.tags.nil?
            p.tags.split(",").each do |t|
              places_tags << t.strip
            end
          end
        end
      end
      places_tags.uniq!

      places_tags.each do |t|
        new_list << t if !tags_array.include?(t)
      end
      new_list.uniq!
      new_list.take(30)
    end
  end



  def map_address
    self.address
  end

  def pub_events
    pub = []
    self.events.each do |ev|
      pub << ev if ev.mystatus == 'published'
    end
    pub
  end

  def pub_deals
    self.deals.where("status='published'")
  end

  def short_description(length=30)
    self.description.titleize[0, length]
  end

  def branch_name
    "#{self.company.name.titleize} #{self.name.titleize}"
  end

  def branches(limit=nil)
    self.company.places.limit(limit)
  end

  def listing
    Listing.find_by_listable_id_and_listable_type(self.id, self.class.name)
  end

  def place
    self
  end

  def promotions
    Announcement.promotions.where("announceable_id=#{self.id} AND announceable_type='Place'").order("created_at DESC")
  end

  def announces
    Announcement.announces.where("announceable_id=#{self.id} AND announceable_type='Place'").order("created_at DESC")
  end

  def event_deal_shouts(limit=100)
    deal_ids = self.pub_deals.map(&:id)
    event_ids = self.pub_events.map(&:id)
    shouts = Shout.where("shoutable_type='Deal' AND shoutable_id IN (?) AND user_id = ?", deal_ids, self.user_id).order("created_at DESC")
    shouts += Shout.where("shoutable_type='Event' AND shoutable_id IN (?) AND user_id = ?", event_ids, self.user_id).order("created_at DESC")
    shouts.sort!{ |a,b| a.created_at <=> b.created_at }
    shouts.reverse!
    shouts.take(limit)
  end

  #pull the latest promotions, announcements, deals, events
  def latest(limit=100)
    latest = []
    latest += self.event_deal_shouts
    latest += self.shouts
    latest += self.promotions
    latest += self.pub_deals
    latest += self.pub_events
    latest.sort!{ |a,b| a.created_at <=> b.created_at }
    latest.reverse!
    latest.take(limit)
  end

  def deals_and_events(orderby="created_at")
    list = []
    list += self.deals
    list += self.events
    unless orderby.nil?
      list.sort!{ |a,b| eval("a.#{orderby}")  <=> eval("b.#{orderby}") }
      list.reverse!
    else
      list
    end
  end

  def roadname
    return "" if self.address.nil?
    unless self.address.nil?
      return self.address.address_roadname rescue ''
    end
  end

  def lotnumber
    return "" if self.address.nil?
    unless self.address.nil?
      return self.address.address_lotnumber rescue ''
    end
  end

  def create_listing
    l = Listing.new
    l.listable = self
    l.listing_type = self.class.name.downcase
    l.category_id = self.category_id
    l.name = self.name
    l.description = self.description
    l.tags = self.tags
    l.website_url = self.website_url
    l.status = 1
    l.save!
  end

  def profile_image
    self.assets.first
  end

  def update_listing
    listing = Listing.find_by_listable_id_and_listable_type(self.id, self.class.name) || Listing.new
    listing.listable = self
    listing.status = 1
    listing.name = self.name
    listing.description = self.description
    listing.tags = self.tags
    listing.listing_type = self.class.name.downcase
    listing.website_url = self.website_url
    listing.category_id = self.category_id
    listing.ranking = self.user.latest_subscription.ranking rescue 0
    listing_user_id = self.user_id
    listing.address_index = self.map_address.complete_address rescue ''
    unless self.highlights.empty?
      h_ids = self.highlights.map(&:highlight_category_id)
      hlights = HighlightCategory.find(h_ids)
      listing.features_index = hlights.map(&:name)
    end
    if self.category.parent.nil?
      listing.category_name = self.category.name rescue ''
    else
      listing.category_name = self.category.parent.name rescue ''
      listing.sub_category_name = self.category.name rescue ''
    end

    cats_string = ""
    unless self.sub_category.nil?
      cat_ids = self.sub_category.split(",")
      cats = Category.find(cat_ids)
      cats.each do |cat|
        cats_string += "#{cat.name} "
      end
      listing.sub_category_name = cats_string
    end

      listing.monfrom = nil
      listing.monfrompm = nil
      listing.monto = nil
      listing.montopm = nil
      listing.tuefrom = nil
      listing.tuefrompm = nil
      listing.tueto = nil
      listing.tuetopm = nil
      listing.wedfrom = nil
      listing.wedfrompm = nil
      listing.wedto = nil
      listing.wedtopm = nil
      listing.thufrom = nil
      listing.thufrompm = nil
      listing.thuto = nil
      listing.thutopm = nil
      listing.frifrom = nil
      listing.frifrompm = nil
      listing.frito = nil
      listing.fritopm = nil
      listing.satfrom = nil
      listing.satfrompm = nil
      listing.satto = nil
      listing.sattopm = nil
      listing.sunfrom = nil
      listing.sunfrompm = nil
      listing.sunto = nil
      listing.suntopm = nil

    if self.operation_hours == "normal"
      times = self.operation_times[:times]
      times.keys.each do |k|
       case k.to_s
         when "monFrom"
           listing.monfrom = times[k].gsub(":","") rescue nil
         when "monTo"
           listing.monto= times[k].gsub(":","") rescue nil
         when "monFromPm"
           listing.monfrompm = times[k].gsub(":","") rescue nil
         when "monToPm"
           listing.montopm = times[k].gsub(":","") rescue nil
         when "tueFrom"
           listing.tuefrom = times[k].gsub(":","") rescue nil
         when "tueFromPm"
           listing.tuefrompm = times[k].gsub(":","") rescue nil
         when "tueTo"
           listing.tueto = times[k].gsub(":","") rescue nil
         when "tueToPm"
           listing.tuetopm = times[k].gsub(":","") rescue nil
         when "wedFrom"
           listing.wedfrom = times[k].gsub(":","") rescue nil
         when "wedFromPm"
           listing.wedfrompm = times[k].gsub(":","") rescue nil
         when "wedTo"
           listing.wedto = times[k].gsub(":","") rescue nil
         when "wedToPm"
           listing.wedtopm = times[k].gsub(":","") rescue nil
         when "thuFrom"
           listing.thufrom = times[k].gsub(":","") rescue nil
         when "thuFromPm"
           listing.thufrompm = times[k].gsub(":","") rescue nil
         when "thuTo"
           listing.thuto = times[k].gsub(":","") rescue nil
         when "thuToPm"
           listing.thutopm = times[k].gsub(":","") rescue nil
         when "friFrom"
           listing.frifrom = times[k].gsub(":","") rescue nil
         when "friFromPm"
           listing.frifrompm = times[k].gsub(":","") rescue nil
         when "friTo"
           listing.frito = times[k].gsub(":","") rescue nil
         when "friToPm"
           listing.fritopm = times[k].gsub(":","") rescue nil
         when "satFrom"
           listing.satfrom = times[k].gsub(":","") rescue nil
         when "satFromPm"
           listing.satfrompm = times[k].gsub(":","") rescue nil
         when "satTo"
           listing.satto = times[k].gsub(":","") rescue nil
         when "satToPm"
           listing.sattopm = times[k].gsub(":","") rescue nil
         when "sunFrom"
           listing.sunfrom = times[k].gsub(":","") rescue nil
         when "sunFromPm"
           listing.sunfrompm = times[k].gsub(":","") rescue nil
         when "sunTo"
           listing.sunto = times[k].gsub(":","") rescue nil
         when "sunToPm"
           listing.suntopm = times[k].gsub(":","") rescue nil
        end
      end
   
    elsif self.operation_hours == "24"
      listing.monfrom = 0
      listing.monfrompm = 0
      listing.monto = 2400
      listing.montopm = 2400
      listing.tuefrom = 0
      listing.tuefrompm = 0
      listing.tueto = 2400
      listing.tuetopm = 2400
      listing.wedfrom = 0
      listing.wedfrompm = 0
      listing.wedto = 2400
      listing.wedtopm = 2400
      listing.thufrom = 0
      listing.thufrompm = 0
      listing.thuto = 2400
      listing.thutopm = 2400
      listing.frifrom = 0
      listing.frifrompm = 0
      listing.frito = 2400
      listing.fritopm = 2400
      listing.satfrom = 0
      listing.satfrompm = 0
      listing.satto = 2400
      listing.sattopm = 2400
      listing.sunfrom = 0
      listing.sunfrompm = 0
      listing.sunto = 2400
      listing.suntopm = 2400
    end

    listing.save!
  end

  def is_published?
    self.status
  end

  def parent_category
    if self.category.parent.nil?
      return self.category
    end
    nil
  end
  
  def subcategory
    unless self.category.parent.nil?
      return self.category
    end
    nil
  end
  
  def highlight_codes
    codes = []

    self.highlights.each do|h|
      codes << h.highlight_category.code rescue nil
    end

    codes
  end

  def update_listing_data
    unless self.listing.nil?
      self.listing.name = self.name
      self.listing.description = self.description
      self.listing.tags = self.tags
      self.listing.website_url = self.website_url
      self.listing.save!
    end

    unless self.deals.empty?
      self.deals.each do |d|
        d.update_listing
      end
    end
  end

  def update_published
    if status == 'published'
      unless self.listing.nil?
        self.listing.name = self.name
        self.listing.description = self.description
        self.listing.tags = self.tags
        self.listing.website_url = self.website_url
        self.listing.save!
      end
    end
  end

  def destroy
    unless self.listing.nil?
      ratings = Rating.where("rateable_type='Listing' AND rateable_id= ?", self.listing.id)
      ratings.destroy_all unless ratings.empty?
      favorites = Favorite.where("likeable_type='Listing' AND id= ?", self.listing.id)
      favorites.destroy_all unless favorites.empty?
      histories = History.where("listing_type='Listing' AND listing_id= ?", self.listing.id)
      histories.destroy_all unless histories.empty?
    end
    super
  end

end
