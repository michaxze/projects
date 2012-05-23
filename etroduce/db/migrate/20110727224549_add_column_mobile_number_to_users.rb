class AddColumnMobileNumberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mobile_number, :string, :null => true
  end

  def self.down
  end
end
