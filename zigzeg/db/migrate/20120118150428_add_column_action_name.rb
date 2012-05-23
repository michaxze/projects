class AddColumnActionName < ActiveRecord::Migration
  def self.up
    add_column :listing_updates, :action_name, :string, :null => true
  end

  def self.down
  end
end
