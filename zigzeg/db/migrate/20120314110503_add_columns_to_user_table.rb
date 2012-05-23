class AddColumnsToUserTable < ActiveRecord::Migration
  def self.up
    add_column :users, :city_name, :string, :null => true
    add_column :users, :state_name, :string, :null => true
    add_column :users, :country_name, :string, :null => true
  end

  def self.down
  end
end
