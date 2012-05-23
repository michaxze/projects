class Event < ActiveRecord::Base
  belongs_to :place
  belongs_to :category
  belongs_to :user
  has_many :assets, :as => :uploadable, :dependent => :destroy
  belongs_to :event
  belongs_to :deal
  has_many :event_dates, :dependent => :destroy
  has_many :ratings, :as => :rateable, :dependent => :destroy
  has_many :highlights, :as => :highlightable, :dependent => :destroy
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_one :address, :as => :addressable, :dependent => :destroy
  has_many :shouts, :as => :shoutable, :dependent => :destroy
  has_one :listing, :as => :listable, :dependent => :destroy

  validates_presence_of :name

  after_save :update_published
  after_update :update_status_published

  class << self
    def search_tag(tags, params = {})
      events = ret = []
      new_list = []
      places_tags = []
      tags_array = []
      tags_array = tags.split(",")
      tags_array.collect!{|t| t.strip }

      tags_array.each do |t|
        unless params[:scat].nil?
          if params[:scat].to_i > 0
            events += where("category_id = ? AND tags like ?", params[:scat].to_i, "%#{t.strip}%").order("created_at DESC")
            events += Place.where("category_id = ? AND tags like ?", params[:scat].to_i, "%#{t.strip}%").order("created_at DESC")
          end
        end

        # if no tags found on sub category events
        if events.empty?
          logger.info("Searching other categories...")
          unless params[:cat].nil?
            if params[:cat].to_i > 0
              cat = Category.find(params[:cat].to_i)
              subcat_ids = cat.subcategories.map(&:id)
              subcat_ids << cat.id
              events += where("category_id IN (?) AND tags like ?", subcat_ids, "%#{t.strip}%").order("created_at DESC")
              events += Place.where("category_id IN (?) AND tags like ?", subcat_ids, "%#{t.strip}%").order("created_at DESC")
            end
          end
        end
      end

      unless events.empty?
        events.each do |p|
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
    self.address || self.place.address
  end

  def short_description
    self.description[0, 100]
  end

  def profile_image
    self.assets.first
  end

  def update_listing
    if ["complete", "published"].include?(self.status.to_s)
      listing = Listing.find_by_listable_id_and_listable_type(self.id, self.class.name) || Listing.new
      listing.listable = self
      listing.status = (self.status == 'published') ? 1 : 0
      listing.name = self.name
      listing.description = self.description
      listing.tags = self.tags
      listing.listing_type = self.class.name.downcase
      listing.website_url = self.website
      listing.category_id = self.category_id
      listing.ranking = self.user.latest_subscription.ranking rescue 0
      listing.user_id = self.user_id

      if self.category.parent.nil?
        listing.category_name = self.category.name rescue ''
      else
        listing.category_name = self.category.parent.name rescue ''
        listing.sub_category_name = self.category.name rescue ''
      end

      if !self.start_time.nil? && !self.end_time.nil?
        listing.monfrom = self.start_time.gsub(":", "")  rescue nil
        listing.monto= self.end_time.gsub(":", "") rescue nil
        listing.tuefrom = self.start_time.gsub(":", "")  rescue nil
        listing.tueto= self.end_time.gsub(":", "") rescue nil
        listing.wedfrom = self.start_time.gsub(":", "")  rescue nil
        listing.wedto= self.end_time.gsub(":", "") rescue nil
        listing.thufrom = self.start_time.gsub(":", "")  rescue nil
        listing.thuto= self.end_time.gsub(":", "") rescue nil
        listing.frifrom = self.start_time.gsub(":", "")  rescue nil
        listing.frito= self.end_time.gsub(":", "") rescue nil
        listing.satfrom = self.start_time.gsub(":", "")  rescue nil
        listing.satto= self.end_time.gsub(":", "") rescue nil
        listing.sunfrom = self.start_time.gsub(":", "")  rescue nil
        listing.sunto= self.end_time.gsub(":", "") rescue nil
      end

      listing.save!
    end
  end

  def is_complete?
    (self.status == 'complete')
  end

  def is_oneday?
    return true if self.event_type == "1"
    return true if self.start_date == self.end_date
    return false
  end

  def is_published?
    (self.status == 'published')
  end

  def expired?
    self.status == Constant::EXPIRED
  end

  def is_deleted?
    self.status == Constant::DELETED
  end

  def mystatus
    # status classes: expired, notlive, inc, complete, published, deleted
    unless self.start_date.nil?
      if self.status == 'complete'
        "notlive"
      elsif self.status == 'published'
        case self.event_type.to_i
        when 1
          if self.start_date.to_date >= Time.now.to_date
            "published"
          else
            "expired"
          end
        when 2
          if self.end_date.to_date >= Time.now.to_date
            "published"
          else
            "expired"
          end
        else
          "published"
        end
      elsif self.status == "expired"
        "expired"
      elsif self.status == "deleted"
        "deleted"
      else
        "inc"
      end
    else
      if [3,4].include?(self.event_type.to_i) and self.status == "published"
        "published"
      elsif self.status == "deleted"
        "deleted"
      else
        "inc"
      end
    end
  end

  def telno
    return self.place.telephone_numbers  if self.use_place_info
    return super
  end

  def faxno
    return self.place.fax_numbers if self.use_place_info
    return super
  end

  def email
    return self.place.email if self.use_place_info
    return super
  end

  def website
    return self.place.website_url if self.use_place_info
    return super
  end

  def facebook
    return self.place.facebook if self.use_place_info
    return super
  end

  def twitter
    return self.place.twitter if self.use_place_info
    return super
  end

  def editable?
    return false if self.status == "deleted"
    tnow = Time.now.to_i
    tpub = self.listing.published_at.to_i rescue 0
    if [3,4].include?(event_type.to_i)
      return false if ((tnow - tpub) / 3600) >= 24
      return true
    end
    return false if start_date.nil?
    return true if self.user.premium_subscriber?
    return false if ((tnow - tpub) / 3600) >= 24
    true
  end

  def destroy
    if self.status == Constant::PUBLISHED || self.status == Constant::EXPIRED
      self.status = "deleted"
      self.sort_status = 5
      self.save

      unless self.listing.nil?
        self.listing.update_attribute(:status, 3)
        favorites = Favorite.where("likeable_type='Listing' AND id= ?", self.listing.id)
        favorites.destroy_all unless favorites.empty?
        Listings.remove_listing_updates(self)
      end
    else
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

  def update_published
    if status == 'published'
      unless self.listing.nil?
        self.listing.name = self.name
        self.listing.description = self.description
        self.listing.tags = self.tags
        self.listing.website_url = self.website
        self.listing.save!
      end
    end
  end

  def update_status_published
    case self.mystatus
    when "published"
      unless self.listing.nil?
        self.listing.update_attribute(:status, 1)
      end
    when "expired"
      unless self.listing.nil?
        self.listing.update_attribute(:status, 2)
      end
    when "notlive"
      unless self.listing.nil?
        self.listing.update_attribute(:status, 0)
      end
    when "inc"
      unless self.listing.nil?
        self.listing.update_attribute(:status, 0)
      end
    end

    if status == 'published'
      unless self.listing.nil?
        self.listing.name = self.name
        self.listing.description = self.description
        self.listing.extra_info = self.extra_info
        self.listing.tags = self.tags
        self.listing.website_url = self.website
        self.listing.save!
      end
    end
  end

end
