class ChangeTypeToMistype < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `messages` CHANGE `type` `msgtype` VARCHAR(255) NULL DEFAULT NULL"
  end

  def self.down
  end
end
