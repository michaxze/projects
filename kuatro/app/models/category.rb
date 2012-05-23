class Category < ActiveRecord::Base
  has_many :albums, :dependent => :destroy
end
