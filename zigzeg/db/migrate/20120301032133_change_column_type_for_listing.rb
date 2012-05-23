class ChangeColumnTypeForListing < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `listings` CHANGE `description` `description` TEXT NULL DEFAULT NULL"
    execute "ALTER TABLE `listings` CHANGE `gallery_title` `gallery_title` TEXT NULL DEFAULT NULL"
    execute "ALTER TABLE `listings` CHANGE `gallery_description` `gallery_description` TEXT NULL DEFAULT NULL"
  end

  def self.down
  end
end
