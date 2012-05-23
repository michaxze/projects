class AddMobileNumberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, "mobileno", :string, :null => true
  end

  def self.down
    remove_column :users, "mobileno"
  end
end
