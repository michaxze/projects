class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  belongs_to :map_address
  belongs_to :country
  belongs_to :state
  belongs_to :city
  belongs_to :section

  def complete_address
    address = []
    address << "#{self.address_lot_number}, " unless self.address_lot_number.blank?
    address << "#{self.floor_number}, " unless self.floor_number.blank?
    address << "#{self.building_name}, " unless self.building_name.blank?
    address << "#{self.address_number}, " unless self.address_number.blank?
    address << "#{self.street}, "  unless self.street.blank?
    address << "#{self.section_name}, " unless self.section_name.blank?
    address << "#{self.postcode}" unless self.postcode.nil?
    address << "#{self.city_name}," unless self.city_name.nil?
    address << "#{self.state_name}," unless self.state_name.nil?
    address << "#{self.country_name}" unless self.country_name.nil?

    address.join(" ")
  end
  
  def latitude
    lat = self.lat
  end
  
  def longitude
    lng = self.lng
  end

  def partial_address
    address = []
    unless self.map_address.nil?
      address << "#{self.lot_number}" rescue ''
      address << "#{self.building_name}" rescue ''
      address << "#{self.map_address.partial_address}," rescue ''
    else
      address << "#{self.address_lot_number}"
      address << "#{self.building_name}"
      address << "#{self.street}" rescue ''
      address << "#{self.section_name}," unless self.section_name.nil?
      address << "#{self.postcode}" unless self.postcode.nil?
      address << "#{self.city_name}," unless self.city_name.nil?
      address << "#{self.state_name}," unless self.city_name.nil?
      address << "#{self.country_name}" unless self.country_name.nil?
    end

    address.join(" ")
  end

  
end
