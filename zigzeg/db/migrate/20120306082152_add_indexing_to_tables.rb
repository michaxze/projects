class AddIndexingToTables < ActiveRecord::Migration
  def self.up
    add_index :places, [:category_id, :tags]
    add_index :listings, :status
    add_index :categories, [:id, :parent_id]
    add_index :users, [:status, :id]
  end

  def self.down
  end
end
