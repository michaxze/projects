class ModifyMessageTable < ActiveRecord::Migration
  def self.up
    remove_column :messages, "user_id"
    remove_column :messages, "to_user_id"

    add_column :messages, "sender_id", :integer
    add_column :messages, "receiver_id", :integer
    add_column :messages, "opportunity_id", :integer
    add_column :messages, "parent_id", :integer
  end

  def self.down
  end
end
