class AddAssetsTAble < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.column "uploadable_id", :integer, :null => true
      t.column "uploadable_type", :string, :null => true
      t.column "description", :string, :null => true
      t.column "file_file_name",     :string
      t.column "file_content_type", :string
      t.column "file_file_size",         :integer
      t.column "file_updated_at",       :datetime
    end
  end

  def self.down
    drop_table :assets
  end
end
