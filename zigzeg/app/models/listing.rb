class Listing < ActiveRecord::Base
  belongs_to :listable, :polymorphic => true
  belongs_to :address
  has_many :assets, :as => :uploadable, :dependent => :destroy
  has_many :ratings, :as => :rateable
  has_many :favorites, :as => :likeable, :dependent => :destroy
  belongs_to :category
  belongs_to :reported_listings
  has_one :place
  belongs_to :user

  serialize :shouts
  serialize :gallery_title
  serialize :gallery_description
  serialize :address_index
  serialize :features_index


  validates_presence_of :listing_type, :listable

  attr_accessor :endpage_url
  cattr_reader :per_page
  self.per_page = Constant::MAP_MORE_NUMBER

  class << self

    def search(search="", options = {})
      search = search.gsub(/'/, "\\\\'") rescue ''
      cat_ids = []
      keyword = search.split(":").first
      search.gsub!("#{keyword}:", "")
      conditions = ["status=1"]
      order = "ranking DESC, published_at DESC"

      conditions << "AND (address_index like '%#{search}%' OR features_index like '%#{search}%' OR category_name like '%#{search}%' OR sub_category_name like '%#{search}%' OR name like '%#{search}%' OR description like '%#{search}%' OR tags like '%#{search}%' OR extra_info like '%#{search}%' OR gallery_title like '%#{search}%' OR gallery_description like '%#{search}%' OR shouts like '%#{search}%' )"

      unless options[:type].blank?
        if options[:type].to_s != "all"
          conditions << "AND listing_type='#{options[:type]}'"
        end
      end

      unless options[:categories].blank?
        cat_ids = options[:categories] if options[:categories].is_a?(Array)
        cids = options[:categories]

       if cids.class == String
          cids = options[:categories].split(",")
          cids.each do |c|
            cat_ids += [c.to_i]
          end
        end

        cats = Category.where("parent_id IN (?)", options[:categories])

        cats.each do |c|
          unless c.nil?
            cat_ids += [c.id.to_i]
          end
        end

        cat_ids.compact!
        conditions << "AND category_id IN (#{cat_ids.join(',')})"
      end

      find(:all, :conditions => conditions.join(" "), :order => order)
    end

    def get(page, search="", options = {})
      page = 0 if page.nil?
      cat_ids = []
      search = search.gsub(/'/, "\\\\'") rescue ''
      keyword = search.split(":").first
      search.gsub!("#{keyword}:", "")
      conditions = ["status=1"]
      condition2 = ["status=1"]
      order = "ranking DESC, published_at DESC"

      unless options[:per_page].nil?
        per_page = options[:per_page].to_i
      else
        per_page = Constant::MAP_MORE_NUMBER
      end

      if options[:bytime].present?
        hour = Time.now.hour.to_s
        min = "%02d" % Time.now.min.to_i
        time = (hour + min).to_i
        day = Time.now.strftime("%a").downcase

        case day
        when "mon"
          conditions << " AND ( (CAST(monfrom as Signed) <= #{time} AND CAST(monto as Signed) >= #{time}) OR (CAST(monfrompm as Signed) <= #{time} AND CAST(montopm as Signed) >= #{time})  )"
        when "tue"
          conditions << " AND ( (CAST(tuefrom as Signed) <= #{time} AND CAST(tueto as Signed) >= #{time}) OR (CAST(tuefrompm as Signed) <= #{time} AND CAST(tuetopm as Signed) >= #{time})  )"
        when "wed"
          conditions << " AND ( (CAST(wedfrom as Signed) <= #{time} AND CAST(wedto as Signed) >= #{time}) OR (CAST(wedfrompm as Signed) <= #{time} AND CAST(wedtopm as Signed) >= #{time})  )"
        when "thu"
          conditions << " AND ( (CAST(thufrom as Signed) <= #{time} AND CAST(thuto as Signed) >= #{time}) OR (CAST(thufrompm as Signed) <= #{time} AND CAST(thutopm as Signed) >= #{time})  )"
        when "fri"
          conditions << " AND ( (CAST(frifrom as Signed) <= #{time} AND CAST(frito as Signed) >= #{time}) OR (CAST(frifrompm as Signed) <= #{time} AND CAST(fritopm as Signed) >= #{time})  )"
        when "sat"
          conditions << " AND ( (CAST(satfrom as Signed) <= #{time} AND CAST(satto as Signed) >= #{time}) OR (CAST(satfrompm as Signed) <= #{time} AND CAST(sattopm as Signed) >= #{time})  )"
        when "sun"
          conditions << " AND ( (CAST(sunfrom as Signed) <= #{time} AND CAST(sunto as Signed) >= #{time}) OR (CAST(sunfrompm as Signed) <= #{time} AND CAST(suntopm as Signed) >= #{time})  )"
        end

        conditions << "
  AND (address_index like '%#{search}%' OR features_index like '%#{search}%' OR category_name like '%#{search}%' OR sub_category_name like '%#{search}%' OR name like '%#{search}%' OR description like '%#{search}%' OR tags like '%#{search}%' OR extra_info like '%#{search}%' OR gallery_title like '%#{search}%' OR gallery_description like '%#{search}%' OR shouts like '%#{search}%'  )"
      else
        conditions << "AND (address_index like '%#{search}%' OR features_index like '%#{search}%' OR category_name like '%#{search}%' OR sub_category_name like '%#{search}%' OR name like '%#{search}%' OR description like '%#{search}%' OR tags like '%#{search}%' OR extra_info like '%#{search}%' OR gallery_title like '%#{search}%' OR gallery_description like '%#{search}%' OR shouts like '%#{search}%'  )"
      end

      unless options[:type].blank?
        if options[:type].to_s != "all"
          conditions << "AND listing_type='#{options[:type]}'"
          condition2 << "AND listing_type='#{options[:type]}'"
        end
      end

      unless options[:categories].blank?
        cat_ids = options[:categories] if options[:categories].is_a?(Array)
        cids = options[:categories]
 
       if cids.class == String
          cids = options[:categories].split(",")
          cids.each do |c|
            cat_ids += [c.to_i]
          end
        end

        cats = Category.where("parent_id IN (?)", cids)
        cats.each do |c|
          unless c.nil?
            cat_ids += [c.id.to_i]
          end
        end

        cat_ids.compact!
        conditions << "AND category_id IN (#{cat_ids.join(',')})"
        condition2 << "AND category_id IN (#{cat_ids.join(',')})"
      end

      unless page.blank?
        page = page.to_i + 1 rescue nil
      end

      if options[:bytime].present?
        all = find :all, :conditions => conditions.join(" "), :order => order
        # special for events
        hour = (Time.now + 2.hours).hour.to_s
        min = "%02d" % (Time.now + 2.hours).min.to_i
        time = (hour + min).to_i
        day = 2.hours.ago.strftime("%a").downcase

        case day
        when "mon"
          condition2 << " AND ( (CAST(monfrom as Signed) <= #{time} AND CAST(monto as Signed) >= #{time})  )"
        when "tue"
          condition2 << " AND ( (CAST(tuefrom as Signed) <= #{time} AND CAST(tueto as Signed) >= #{time})  )"
        when "wed"
          condition2 << " AND ( (CAST(wedfrom as Signed) <= #{time} AND CAST(wedto as Signed) >= #{time})  )"
        when "thu"
          condition2 << " AND ( (CAST(thufrom as Signed) <= #{time} AND CAST(thuto as Signed) >= #{time})  )"
        when "fri"
          condition2 << " AND ( (CAST(frifrom as Signed) <= #{time} AND CAST(frito as Signed) >= #{time})  )"
        when "sat"
          condition2 << " AND ( (CAST(satfrom as Signed) <= #{time} AND CAST(satto as Signed) >= #{time})  )"
        when "sun"
          condition2 << " AND ( (CAST(sunfrom as Signed) <= #{time} AND CAST(sunto as Signed) >= #{time})  )"
        end

        condition2 << " AND listing_type='event' AND (address_index like '%#{search}%' OR features_index like '%#{search}%' OR category_name like '%#{search}%' OR sub_category_name like '%#{search}%' OR name like '%#{search}%' OR description like '%#{search}%' OR tags like '%#{search}%' OR extra_info like '%#{search}%' OR gallery_title like '%#{search}%' OR gallery_description like '%#{search}%' OR shouts like '%#{search}%'  )"

        events = find :all, :conditions => condition2.join(" "), :order => order
        listings = all + events
        listings.uniq!

        finallist = []
        listings.each do |l|
          if l.listable_type == 'Event'
            case l.listable.event_type.to_s
            when "1"
              unless l.listable.nil?
                unless l.listable.start_date.nil?
                  finallist << l if l.listable.start_date.to_date == Time.now.to_date
                end
              end
            when "2"
              unless l.listable.nil?
                unless l.listable.start_date.nil?
                  finallist << l if l.listable.start_date <= Time.now.to_date && l.listable.end_date.to_date >= Time.now.to_date
                end
              end
            when "3"
              finallist << l if l.listable.event_day == Time.now.strftime("%a").downcase
            when "4"
              finallist << l if l.listable.event_day.to_s == Time.now.day.to_s
            end
          else
            finallist << l
          end
        end

        start_num = ((15*page.to_i) - 15)
        end_num =  (15*page.to_i) - 1

        finallist[start_num..end_num]
      else
        paginate :page => page,
               :conditions => conditions.join(" "),
               :order => order,
               :per_page => per_page
      end
    end

    def recommendations(limit = 8)
      find( :all,
            :conditions => "status=1",
            :order => "ranking DESC, published_at DESC",
            :limit => limit )
    end

    def get_unread_posts(user, type='place', limit=50)
      reads = MarkedViewed.find(:all, :conditions => ["user_id=? AND listing_created_at > ?", user.id, 1.month.ago.to_date])
      listing_ids = reads.map(&:listing_id).uniq

      unless listing_ids.empty?
        find( :all,
            :conditions => ["status=1 AND listing_type=? AND created_at > ? AND id NOT IN (?)", type, 1.month.ago.to_date, nil],
	    :limit => limit,
            :order => "ranking DESC, created_at DESC" )
      else
        find( :all,
            :conditions => ["status=1 AND listing_type=? AND created_at > ?", type, 1.month.ago.to_date],
	    :limit => limit,
            :order => "ranking DESC, created_at DESC" )
      end
    end

    def get_mostpopular(type=nil, limit=8)
      unless type.nil?
        find( :all,
              :conditions => ["status=1 AND listing_type=?", type],
              :order => "ranking DESC, published_at DESC" )
      else
        find( :all,
              :conditions => ["status=1"],
              :order => "ranking DESC, published_at DESC" )
      end
    end

    def latest(except=nil, type=nil, limit=5)
      unless except.nil?
        find(:all, :conditions => ["status=1 AND id != ?", except.id], :order => "published_at DESC", :limit => limit)
      else
        find(:all, :conditions => ["status=1"], :order => "published_at DESC", :limit => limit)
      end
    end

  end

  def rating
    total = 0
    if self.ratings.length > 0
      self.ratings.each{|r| total += r.value.to_i}
      total / self.ratings.length
    else
      0
    end
  end

  def nlikes
    self.favorites.length
  end

  def related_listings(limit = 5)
    listings = []
    listings += self.category.pub_listings(self)
    listings.take(limit)
  end

  def short_description(length=30)
    self.description[0, length]
  end
  
  def endpage_url
    url = Yetting.domain + "/"
    object = self.listable
    
    if object.class.name == "Place"
      url += "#{object.page_code}"
    elsif object.class.name == "Announcement"
      url += "#{object.announceable.page_code}/announcements/#{object.id}"
    elsif object.class.name == "Event"
      url += "#{object.place.page_code}/events/#{object.page_code}"
    elsif object.class.name == "Deal"
      url += "#{object.place.page_code}/deals/#{object.page_code}"
    else
      unless object.listable.nil?
        if object.listable.class.name == "Event"
          url += "#{object.listable.place.page_code}/events/#{object.listable.page_code}"
        elsif object.listable.class.name == "Deal"
          url += "#{object.listable.place.page_code}/deals/#{object.listable.page_code}"
        elsif object.listable.class.name == "Place"
          url += "#{object.listable.page_code}"
        end
      end
    end

    url
  end
  
  def profile_icon
    image_path = case self.listing_type
    when "deal", "event"
      self.listable.pictures.first.image.url(:thumb) rescue ''
    when "place"
      self.listable.profile_image.image.url(:thumb) rescue '' 
    else
    ''
    end
    image_path
  end
  
  def as_json(*args)
    hash = super(*args)
    hash.merge!('endpage_url' => self.endpage_url)
    hash.merge!('image_icon' => self.profile_icon)
    hash.merge!('lat' => self.listable.map_address.lat)
    hash.merge!('lng' => self.listable.map_address.lng)
  end

  def package
   pkg = self.listable.user.latest_subscription rescue nil
   return nil if pkg.nil?
   pkg
  end
end
