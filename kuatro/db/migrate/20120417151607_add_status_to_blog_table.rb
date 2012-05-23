class AddStatusToBlogTable < ActiveRecord::Migration
  def self.up
    add_column :blogs, :status, :string, :default => "publish"
  end

  def self.down
  end
end
