class AddImagesTable < ActiveRecord::Migration
  def self.up
    create_table   :assets, :force => true do |t|
      t.integer    :created_by
      t.integer    :opportunity_id
      t.timestamps
    end
    
    add_column :assets, :image_file_name,    :string
    add_column :assets, :image_content_type, :string
    add_column :assets, :image_file_size,    :integer
    add_column :assets, :image_updated_at,   :datetime
  end

  def self.down
  end
end