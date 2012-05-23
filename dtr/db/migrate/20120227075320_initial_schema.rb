class InitialSchema < ActiveRecord::Migration
  def up
    create_table :admins do |t|
      t.database_authenticatable
      t.timestamps
    end
    
    create_table :companies do |t|
      t.string :name
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table :admins
  end
end
