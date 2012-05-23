class AddTableThreads < ActiveRecord::Migration
  def self.up
    create_table :message_threads, :force => true do |t|
      t.string    :subject
      t.integer   :to_id
      t.integer   :from_id
      t.integer   :opportunity_id
      t.boolean   :has_read, :default => false
      t.timestamps
    end    
    add_index :message_threads, :to_id
    add_index :message_threads, :from_id
    
  end

  def self.down
  end
end
