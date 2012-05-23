class CreateSubscribers < ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string :company_name, :null => true
      t.string :email, :null => true
      t.string :business_type, :null => true
      t.string :contact_person, :null => true
      t.string  :contact_number, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :subscribers
  end
end
