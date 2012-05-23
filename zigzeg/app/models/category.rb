class Category < ActiveRecord::Base
  has_many :subcategories, :foreign_key => "parent_id", :class_name => "Category", :dependent => :destroy
  has_many :places, :class_name => "Listing", :conditions => "listing_type='place'"
  has_many :events, :class_name => "Listing", :conditions => "listing_type='event'"
  has_many :deals,  :class_name => "Listing", :conditions => "listing_type='deal'"
  has_many :category_features
  belongs_to :parent, :class_name => "Category"
  attr_accessor :parent_category

  scope :subcategories, lambda { |cat|
    where("parent_id IS NOT NULL AND parent_id = ?", cat.id)
  }

  scope :parent_categories, lambda {
    where("parent_id IS NULL")
  }

  self.per_page = 10

  class << self
    def create_update(new_name, category=nil)
      cat = Category.find_by_name(new_name) || Category.new(:name => new_name)
      cat.code = new_name
      cat.parent = category unless category.nil?
      cat.save!
      cat
    end

    def ordered_byparent(sub = '')
      categories = []
      parents = Category.where("parent_id IS NULL").order("name ASC")

      unless sub.blank?
        parents.each { |cat| categories << cat; categories += cat.subcategories }
      else
        categories = parents
      end

      categories
    end

    def parent_categories_options
      options = []
      Category.parent_categories.each do|parent|
        options << [parent.name.titleize, parent.id]
      end
      options
    end

    def get_parents(page)
      paginate :page => page,  :conditions => "parent_id IS NULL"
    end
    
  end
  
  def is_subcategory?
    (self.parent_id != nil)
  end

  def is_parentcategory?
    (self.parent_id == nil)
  end

  def pub_listings(listing, options = {})
    listings = []

    if listing.listing_type == 'place'
      if options[:notrelated].present?
        cat_ids = [self.id]
        cat_ids <<  self.parent_id
        listings =  Listing.where("status=1 AND listing_type = ? AND category_id IN (?) AND id <> ?", listing.listing_type, cat_ids, listing.id).order("created_at DESC").limit(5)
      else
        d_ids = listing.listable.pub_deals.map(&:id)
        listings = Listing.where("listable_type='Deal' AND listable_id IN (?)", d_ids)

        e_ids = listing.listable.pub_events.map(&:id)
        listings += Listing.where("listable_type='Event' AND listable_id IN (?)", e_ids)
     end
    else
      place = listing.listable.place
      if listing.listing_type == 'deal'
        d_ids = place.pub_deals.map(&:id)
        listings = Listing.where("listable_type='Deal' AND listable_id IN (?)", d_ids)
      else
        e_ids = place.pub_events.map(&:id)
        listings += Listing.where("listable_type='Event' AND listable_id IN (?)", e_ids)
      end

      cat_ids = [self.id]
      cat_ids <<  self.parent_id
      event_deal = ['event', 'deal']
      listings = Listing.where("status=1 AND listing_type IN (?) AND category_id IN (?) AND id <> ?", event_deal, cat_ids, listing.id).order("created_at DESC").limit(5)
    end

    listings.uniq
  end
end
