class AddViewedProfileColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :viewed_profile, :boolean, :default => false
  end

  def self.down
    drop_column :users, :viewed_profile
  end
end
