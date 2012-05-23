class SetZipcodeToNotNull < ActiveRecord::Migration
  def self.up
    change_column :users, :zipcode, :string, :null => true
  end

  def self.down
  end
end
