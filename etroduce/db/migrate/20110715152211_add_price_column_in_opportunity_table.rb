class AddPriceColumnInOpportunityTable < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  end
end
