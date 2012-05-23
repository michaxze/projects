class Country < ActiveRecord::Base

  class << self
    def search_name(name)
      c = Country.find_by_name("Malaysia")
      where("LOWER(name) like ? AND id=?", "%#{name}%", c.id).limit(10)
    end
  end

end
