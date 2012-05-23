class AddColumnViewsToOpportunities < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :views, :integer
  end

  def self.down
    remove_column :opportunities, :views
  end
end
