class EventDate < ActiveRecord::Base
  belongs_to :event
  has_one :address, :as => :addressable

end
