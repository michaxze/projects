class AddColumnPostTypeToOpportunities < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :post_type, :string, :default => "personal"
  end

  def self.down
  end
end
