class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.decimal :price_monthly
      t.decimal :price_per_post
      t.date :expire_at

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
