class AddTableIntegrations < ActiveRecord::Migration
  def self.up
    create_table :socials, :force => true do |t|
      t.integer :user_id
      t.string :provider
      t.integer  :uid
      t.text :info
      t.text :credentials
      t.text :extra
      t.timestamps
    end
  end

  def self.down
  end
end
