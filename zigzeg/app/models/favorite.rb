class Favorite < ActiveRecord::Base
  belongs_to :likeable, :polymorphic => true
  belongs_to :user

  scope :recent, lambda { where("created_at > ?", 5.day.ago ) }

  class << self
    def create_zig(listing, user)
      f = Favorite.find_by_likeable_id_and_likeable_type_and_user_id(listing.id, listing.class.name, user.id) \
	|| Favorite.create!(:user => user, :likeable => listing)
    end
  end
end
