class CreateCategoryFeatures < ActiveRecord::Migration
  def self.up
    create_table :category_features do |t|
      t.integer :category_id
      t.string :name
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :category_features
  end
end
