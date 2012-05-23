class AddColumnSenderMessageIdToMessagesTable < ActiveRecord::Migration
  def self.up
    add_column :messages, :sender_message_id, :string, :null => true;
  end

  def self.down
  end
end
