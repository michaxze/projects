class DeleteAndCreateMessageTable < ActiveRecord::Migration
  def self.up
    create_table :messages, :force => true do |t|
      t.integer :to_id,             :null => false
      t.integer :from_id,           :null => false
      t.string  :body,              :null => false
      t.text    :message_thread_id, :null => false
      t.integer :viewable_to,       :null => false
      t.string   :msgtype,          :null => false
      t.datetime :read_at
      t.timestamps
    end
    add_index :messages, :to_id
    add_index :messages, :from_id
    add_index :messages, [:msgtype, :to_id]
    add_index :messages, [:msgtype, :from_id]
  end

  def self.down
  end
end
