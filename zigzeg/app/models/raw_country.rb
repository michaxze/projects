class RawCountry < ActiveRecord::Base
  has_many :regions, :primary_key => "CountryId", :foreign_key => "CountryID"
end
