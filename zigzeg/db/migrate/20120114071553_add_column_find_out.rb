class AddColumnFindOut < ActiveRecord::Migration
  def self.up
    add_column :users, :find_out, :string, :null => true
  end

  def self.down
  end
end
