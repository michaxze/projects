class Product < ActiveRecord::Base
  belongs_to :place
  has_many :assets, :as => :uploadable
end
