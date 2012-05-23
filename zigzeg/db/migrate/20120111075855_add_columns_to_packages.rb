class AddColumnsToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :price_per_day, :decimal, :precision => 8, :scale => 2
    add_column :packages, :price_per_month, :decimal, :precision => 8, :scale => 2
    add_column :packages, :price_per_year, :decimal, :precision => 8, :scale => 2
    add_column :packages, :sales_tax, :decimal, :precision => 8, :scale => 2
    add_column :packages, :logo_on_map, :boolean, :default => false
    add_column :packages, :aboutus_characters, :integer, :default => -1
    add_column :packages, :allowed_shouts, :integer, :default => 0
    add_column :packages, :customer_service, :boolean, :default => false
  end

  def self.down
  end
end
