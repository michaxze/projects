class AddImageColumnToFeatures < ActiveRecord::Migration
  def self.up
    add_column :highlight_categories, :image, :string, :null => true
    add_column :category_features, :image, :string, :null => true
  end

  def self.down
  end
end
