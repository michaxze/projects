class AddCatSubInListing < ActiveRecord::Migration
  def self.up
    add_column :listings, :category_name, :string, :null => true
    add_column :listings, :sub_category_name, :string, :null => true
  end

  def self.down
    drop_column :listings, :category_name
    drop_column :listings, :sub_category_name
  end
end
