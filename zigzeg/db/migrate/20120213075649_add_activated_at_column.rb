class AddActivatedAtColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :activated_at, :datetime, :null => true
  end

  def self.down
  end
end
