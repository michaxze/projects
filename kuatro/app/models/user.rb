class User < ActiveRecord::Base
  has_many :albums
end
