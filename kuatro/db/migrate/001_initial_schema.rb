class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.column "title", :string, :null => false
      t.column "contents", :text
      t.column "page_code", :string
      t.column "authorable_id", :integer
      t.column "authorable_type", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table :users do |t|
      t.column "name", :string
      t.column "email", :string
      t.column "password", :string
      t.column "role", :string, :null => true
      t.column "status", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table :categories do |t|
      t.column "name", :string
      t.timestamps
    end
    
    create_table :albums do |t|
      t.column "category_id", :integer
      t.column "name", :string
      t.column "hidden", :boolean, :default => false
      t.column "user_id", :integer
      t.timestamps
    end
    
    create_table :pictures do |t|
      t.column "album_id", :integer
      t.column "hidden", :boolean, :default => false
      t.column "description", :string
      t.column "image_file_name",     :string
      t.column "image_content_type", :string
      t.column "image_file_size",         :integer
      t.column "image_updated_at",       :datetime
      t.timestamps
    end

    create_table :featured_images do |t|
      t.column "description",   :string
      t.column "fimage_file_name",     :string
      t.column "fimage_content_type", :string
      t.column "fimage_file_size",         :integer
      t.column "fimage_updated_at",       :datetime
      t.timestamps
    end

    create_table :contents do |t|
      t.column "code",   :string
      t.column "contents", :text
      t.timestamps
    end
    
  end
end
