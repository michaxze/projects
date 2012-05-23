class City <  ActiveRecord::Base
  has_many :sections
  belongs_to :state
  
  class << self
    def search_city(city)
      c = Country.find_by_name("Malaysia")
      states = State.where("country_id=?", c.id)
      state_ids = states.map(&:id)

      where("name like ? AND state_id IN (?)", "%#{city}%", state_ids).limit(10)
    end
  end
end
