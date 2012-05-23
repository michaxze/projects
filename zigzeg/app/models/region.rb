class Region < ActiveRecord::Base
  belongs_to :raw_country
  has_many :raw_cities, :primary_key => "RegionID", :foreign_key => "RegionID"
end
