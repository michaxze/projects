class CreateInboundSmsTable < ActiveRecord::Migration
  def self.up
    create_table :inbound_sms, :force => true do |t|
      t.integer :destination_address
      t.string :message
      t.string :message_id
      t.integer :sender_address
      t.datetime :date_sent
      t.timestamps
    end
  end

  def self.down
  end
end
