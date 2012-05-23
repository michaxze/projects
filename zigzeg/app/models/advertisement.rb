class Advertisement < ActiveRecord::Base
  has_one :asset, :as => :uploadable, :dependent => :destroy
  belongs_to :advertiser, :polymorphic => true
  belongs_to :creator, :polymorphic => true
end
