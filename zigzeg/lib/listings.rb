require 'rubygems'
require 'webrick'

module Listings

  def self.remove_listing_updates(object)
    updates = case object.class.name
    when "Event", "Deal", "Place"
      ListingUpdate.where("updateable_id = ? AND updateable_type=?", object.id, object.class.name)
    end
    updates.delete_all
  end

  def self.is_name_unique(name, type='place', id=nil)
    obj = type.classify.constantize.find(id) unless id.nil?

    case type
    when "place"
      unless obj.nil?
        found = Place.where("name = ? AND id <> ?", name, obj.id).first rescue nil
      else
        found = Place.find_by_name(name) rescue nil
      end
    when "event"
      unless obj.nil?
        found = Event.where("name = ? AND id <> ?", name, obj.id).first rescue nil
      else
        found = Event.find_by_name(name) rescue nil
      end
    when "deal"
      unless obj.nil?
        found = Deal.where("name = ? AND id <> ?", name, obj.id).first rescue nil
      else
        found = Deal.find_by_name(name) rescue nil
      end
    end
    return true if found
    return false
  end
end
