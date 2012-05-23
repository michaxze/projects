class AddFacebookInfoColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, "provider", :string, :null => true
    add_column :users, "uid", :string, :null => true
    add_column :users, "image_facebook", :string, :null => true
    add_column :users, "gender", :string, :null => true
    add_column :users, "timezone", :integer, :null => true
  end

  def self.down
  end
end
