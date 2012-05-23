class AddColumnsToListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :gallery_title, :string, :null => true
    add_column :listings, :gallery_description, :string, :null => true
    add_column :listings, :shouts, :text, :null => true
    execute "ALTER TABLE `listings` CHANGE `event_info` `extra_info` TEXT NULL DEFAULT NULL"
  end

  def self.down
  end
end
