class AddUsePlaceInfo < ActiveRecord::Migration
  def self.up
    add_column :deals, :use_place_info, :boolean, :default => true
    add_column :events, :use_place_info, :boolean, :default => true
  end

  def self.down
  end
end
