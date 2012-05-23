class AddColumnToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :address_index, :text, :null => true
    add_column :listings, :features_index, :text, :null => true
  end

  def self.down
    drop_column :listings, :address_index
    drop_column :listings, :features_index
  end
end
