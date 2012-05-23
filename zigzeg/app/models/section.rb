class Section < ActiveRecord::Base
  belongs_to :city
  
  class << self
    def search_postcode(pcode)
      where("postalcode like ?", "%#{pcode}%").limit(10)
    end
    
    def search_section(section)
      where("name like ?", "%#{section}%").limit(10)
    end
  end
end
