class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.string   :title
      t.text     :contents
      t.string   :author
      t.string   :alignment
      t.string   :timage_description
      t.string   :timage_file_name
      t.string   :timage_content_type
      t.integer  :timage_file_size
      t.datetime :timage_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :letters
  end
end
