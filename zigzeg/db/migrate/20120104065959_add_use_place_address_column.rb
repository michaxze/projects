class AddUsePlaceAddressColumn < ActiveRecord::Migration
  def self.up
    add_column :events, :use_place_address, :boolean, :default => true
    add_column :deals,  :use_place_address, :boolean, :default => true
  end

  def self.down
  end
end
