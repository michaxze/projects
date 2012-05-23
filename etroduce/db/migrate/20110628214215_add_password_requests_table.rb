class AddPasswordRequestsTable < ActiveRecord::Migration
  def self.up
    create_table :password_requests , :force => true do |t|
      t.string  :email
      t.string  :token
      t.timestamps
    end
  end

  def self.down
  end
end
