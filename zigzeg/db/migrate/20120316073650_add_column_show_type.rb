class AddColumnShowType < ActiveRecord::Migration
  def self.up
    add_column :notifications, :show_type, :string, :default => Constant::BOTH
  end

  def self.down
    drop_column :notification, :show_type
  end
end
