class State < ActiveRecord::Base
  has_many :cities
  belongs_to :country

  class << self
    def search_name(name)
      c = Country.find_by_name("Malaysia")
      where("LOWER(name) like ? AND country_id=?", "%#{name}%", c.id).limit(10)
    end
  end
end
