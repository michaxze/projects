class Shout < ActiveRecord::Base
  belongs_to :shoutable, :polymorphic => true
  belongs_to :user

  after_save :update_listing
  after_update :update_listing


  def update_listing
    unless self.shoutable.nil?
      unless self.shoutable.listing.nil?
        shouts = self.shoutable.shouts.map(&:content)
        shouts.compact!
        self.shoutable.listing.update_attribute(:shouts, shouts)
      end
    end
  end
end
