class AddColumnCategoryFeatures < ActiveRecord::Migration
  def self.up
    add_column :places, :category_features, :text
  end

  def self.down
  end
end
