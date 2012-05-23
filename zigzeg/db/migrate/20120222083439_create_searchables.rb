class CreateSearchables < ActiveRecord::Migration
  def self.up
    create_table :searchables do |t|
      t.string :text
      t.integer :searchable_id
      t.string :searchable_type
      t.string :column_name

      t.timestamps
    end
  end

  def self.down
    drop_table :searchables
  end
end
