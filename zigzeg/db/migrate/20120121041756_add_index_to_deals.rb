class AddIndexToDeals < ActiveRecord::Migration
  def self.up
    add_index :deals, [:place_id, :status]
  end

  def self.down
  end
end
