class AddShownColumnToListingUpdate < ActiveRecord::Migration
  def self.up
    add_column :listing_updates, :shown, :boolean, :default => true
  end

  def self.down
    drop_column :listing_updates, :shown
  end
end
