class AddExpressTokenToOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :cart_id
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on
      t.timestamps
    end

    add_column :orders, :express_token, :string
    add_column :orders, :express_payer_id, :string
  end

  def self.down
    remove_column :orders, :express_payer_id
    remove_column :orders, :express_token
  end
end
