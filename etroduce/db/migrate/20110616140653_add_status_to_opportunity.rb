class AddStatusToOpportunity < ActiveRecord::Migration
  def self.up
    add_column :opportunities, "status", :boolean, :default => false
  end

  def self.down
    remove_column
  end
end