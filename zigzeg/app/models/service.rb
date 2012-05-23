class Service < ActiveRecord::Base
  belongs_to :place
  has_many :assets, :as => :uploadble
end
