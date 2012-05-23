class StatusChangeColumnType < ActiveRecord::Migration
  def self.up
    change_column :listings, :status, :integer
  end

  def self.down
  end
end
