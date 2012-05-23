class Album < ActiveRecord::Base
  has_many :pictures, :dependent => :destroy
  belongs_to :user
  belongs_to :category
end
