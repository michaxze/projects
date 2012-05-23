class AddColumnsToCity < ActiveRecord::Migration
  def self.up
    add_column :cities, :timezone, :string
    add_column :cities, :lat, :string
    add_column :cities, :lng, :string
  end

  def self.down
  end
end
