class MapAddress < ActiveRecord::Base
  belongs_to :country
  belongs_to :state
  belongs_to :city
  belongs_to :section

  class << self
    def search_address(address)
      MapAddress.where("street like ?", "%#{address}%").limit(10)
    end
    
    def search_building(building_name)
      MapAddress.where("building_name like ?", "%#{building_name}%").limit(10)
    end
    
  end
  
  def partial_address
    address = []
    address << self.street rescue ''
    address << "#{self.section.name} #{self.section.postalcode}"
    address << self.city.name rescue ''
    address << self.state.name rescue ''
    address << self.country.name rescue ''
    address.join(", ")
  end

end