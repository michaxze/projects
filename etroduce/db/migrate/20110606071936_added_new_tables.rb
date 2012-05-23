class AddedNewTables < ActiveRecord::Migration
  def self.up
    create_table :categories, :force => true do |t|
      t.string :name
      t.string :code
    end
    add_index :categories, :code
    
    create_table :invitations, :force => true do |t|
      t.integer :user_id
      t.string :email
      t.string :firstname
      t.string :lastname
      t.text   :message
      t.date   :confirmed_at
      t.timestamps
    end
    
    add_column :messages, :type, :string, :default => "personal"
    
  end

  def self.down
  end
end
