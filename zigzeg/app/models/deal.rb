class Deal < ActiveRecord::Base
  #0 - incomplete
  #01 - about to go live
  #1 - live
  #2 -
  #3 -
  #4 - expired
  #5 - deleted
  belongs_to :place
  belongs_to :category
  has_many :assets, :as => :uploadable, :dependent => :destroy
  has_many :ratings, :as => :rateable, :dependent => :destroy
  has_one :address, :as => :addressable, :dependent => :destroy
  has_many :highlights, :as => :highlightable, :dependent => :destroy
  has_many :pictures, :as => :pictureable, :dependent => :destroy
  has_many :shouts, :as => :shoutable, :dependent => :destroy
  has_one :listing, :as => :listable, :dependent => :destroy
  belongs_to :user

  scope :published, lambda { |place|
    where("status=1 AND place_id = ?", place.id)
  }

  serialize :locations

  after_save :update_published
  after_update :update_status_published

  class << self
    def search_tag(tags, params = {})
      deals = ret = []
      new_list = []
      places_tags = []
      tags_array = []
      tags_array = tags.split(",")
      tags_array.collect!{|t| t.strip }

      tags_array.each do |t|
        unless params[:scat].nil?
          if params[:scat].to_i > 0
            deals += where("category_id = ? AND tags like ?", params[:scat].to_i, "%#{t.strip}%").order("created_at DESC")
            deals += Place.where("category_id = ? AND tags like ?", params[:scat].to_i, "%#{t.strip}%").order("created_at DESC")
          end
        end

        # if no tags found on sub category deals
        if deals.empty?
          logger.info("Searching other categories...")
          unless params[:cat].nil?
            if params[:cat].to_i > 0
              cat = Category.find(params[:cat].to_i)
              subcat_ids = cat.subcategories.map(&:id)
              subcat_ids << cat.id
              deals += where("category_id IN (?) AND tags like ?", subcat_ids, "%#{t.strip}%").order("created_at DESC")
              deals += Place.where("category_id IN (?) AND tags like ?", subcat_ids, "%#{t.strip}%").order("created_at DESC")
            end
          end
        end
      end

      unless deals.empty?
        deals.each do |p|
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
      if self.ongoing?
        if self.start.to_date <= Time.now.to_date
          self.update_attribute(:status, 'published')
        else
          self.update_attribute(:status, 'complete')
        end
      else
        if self.start.to_date <= Time.now.to_date && self.end.to_date >= Time.now.to_date
          self.update_attribute(:status, 'published')
        else
          self.update_attribute(:status, 'complete')
        end
      end

      listing = Listing.find_by_listable_id_and_listable_type(self.id, self.class.name) || Listing.new
      listing.listable = self
      listing.status = (self.status == "published" ? 1 : 0)
      listing.name = self.name
      listing.description = self.description
      listing.tags = self.tags
      listing.website_url = self.website
      listing.listing_type = self.class.name.downcase
      listing.category_id = self.category_id
      listing.ranking = self.user.latest_subscription.ranking rescue 0
      listing.user_id = self.user_id

      if self.category.parent.nil?
        listing.category_name = self.category.name rescue ''
      else
        listing.category_name = self.category.parent.name rescue ''
        listing.sub_category_name = self.category.name rescue ''
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

    if self.place.operation_hours == "normal"
      times = self.place.operation_times[:times]
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
    elsif self.place.operation_hours == "24"
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
  end

  def is_oneday?
    return false if self.ongoing?
    return true if self.start == self.end
    return false
  end

  def is_published?
    self.status == Constant::PUBLISHED
  end

  def is_complete?
    self.status == Constant::COMPLETE
  end

  def expired?
    self.status == Constant::EXPIRED
  end

  def is_deleted?
    self.status == Constant::DELETED
  end

  def mystatus
    # status classes: expired, notlive, inc, complete, published, deleted
    unless self.start.nil?
      if self.status == 'published'
        if self.ongoing
          "published"
        else
          unless self.end.nil?
            if self.start.to_date <= Time.now.to_date && self.end.to_date >= Time.now.to_date
              "published"
            elsif self.start.to_date > Time.now.to_date
              "notlive"
            else
              "expired"
            end
          end
        end
      elsif self.status == 'complete'
        "notlive"
      elsif self.status == "expired"
        "expired"
      elsif self.status == "deleted"
        "deleted"
      else
        "inc"
      end
    else
      "inc"
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
    return false if start.nil?
    return false if self.status == "deleted"
    return true if self.user.premium_subscriber?
    tnow = Time.now.to_i
    tpub = self.listing.published_at.to_i
    return true if Time.now.to_date == self.start.to_date
    return true if self.start.to_date > Time.now.to_date
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
      end
      Listings.remove_listing_updates(self)
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

  def update_status_published
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

end
