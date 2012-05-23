class AddColumnPlaceId < ActiveRecord::Migration
  def self.up
    add_column :readables, :place_id, :integer
  end

  def self.down
  end
end
