class AddStateNameColumn < ActiveRecord::Migration
  def self.up
    add_column :addresses, :state_name, :string, :null => true
    add_column :addresses, :country_name, :string, :null => true
  end

  def self.down
  end
end
