class AddColumnsToContactLists < ActiveRecord::Migration
  def self.up
    add_column :contact_lists, :description, :string, :null => true
    add_column :contact_lists, :privacy, :integer, :default => 0
  end

  def self.down
  end
end
