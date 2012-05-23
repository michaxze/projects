class AddRankingColumnToListing < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `listings` CHANGE `package` `ranking` INT( 255 ) NULL DEFAULT NULL"
  end

  def self.down
  end
end
