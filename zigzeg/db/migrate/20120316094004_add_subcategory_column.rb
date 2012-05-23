class AddSubcategoryColumn < ActiveRecord::Migration
  def self.up
    add_column :places, :sub_category, :string, :null => true
  end

  def self.down
    drop_column :places, :sub_category
  end
end
