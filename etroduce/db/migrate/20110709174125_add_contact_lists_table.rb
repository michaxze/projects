class AddContactListsTable < ActiveRecord::Migration
  def self.up
    create_table :contact_lists, :force => true do |t|
      t.integer :user_id
      t.string  :name
      t.timestamps
    end
    add_index :contact_lists, :user_id

    create_table :users_contact_lists, :force => true do |t|
      t.integer :user_id
      t.integer :contact_list_id
      t.integer :contact_user_id
      t.timestamps
    end
    add_index :users_contact_lists, :user_id
    add_index :users_contact_lists, [ :user_id, :contact_list_id ]
  end

  def self.down
  end
end
