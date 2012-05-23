class AddRemarksToOpportunities < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :parent_post_id, :integer
    add_column :opportunities, :remarks, :text
  end

  def self.down
  end
end
