class Organizer < ActiveRecord::Base
  has_one  :asset, :as => :uploadable, :dependent => :destroy
end
