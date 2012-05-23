class CreateShouts < ActiveRecord::Migration
  def self.up
    create_table :shouts do |t|
      t.integer :user_id
      t.integer :shoutable_id
      t.string  :shoutable_type
      t.string  :content

      t.timestamps
    end
  end

  def self.down
    drop_table :shouts
  end
end
