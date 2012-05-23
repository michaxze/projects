class InitSchema < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :email
      t.string :password
      t.string :firstname
      t.string :lastname
      t.string :registration_token
      t.recoverable
      t.confirmable
      t.rememberable
      t.datetime :deactivated_at
      t.datetime :setup_at
      t.datetime :verified_identity_at
      t.timestamps
    end
    add_index :users, :email, :unique => true

    create_table :contacts, :force => true do |t|
      t.integer :user_id
      t.integer :contact_user_id
      t.date    :confirmed_at 
      t.timestamps
    end
    add_index :contacts, :user_id
    
    
    create_table :opportunities, :force => true do |t|
      t.belongs_to :user
      t.string :subject
      t.text :description
      t.string :zipcode
      t.date :expire_at
      t.datetime :closed_at
      t.string :location
      t.string :country
      t.integer(:privacy, :null => false, :default => Etro::PRIVACY_LEVELS[:private])
      t.date :created_at
      t.date :updated_at
    end
    add_index :opportunities, :user_id
    add_index :opportunities, :expire_at

    create_table :messages, :force => true do |t|
      t.integer :user_id, :null => false
      t.integer :to_user_id, :null => false
      t.string  :subject, :null => false
      t.text    :body, :null => false
      t.datetime :read_at
      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :to_user_id
    add_index :messages, :read_at
  end
  
  def self.down
    # TBD:
  end
end
