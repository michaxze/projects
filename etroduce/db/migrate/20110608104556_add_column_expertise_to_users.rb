class AddColumnExpertiseToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, "expertise", :string
  end

  def self.down
    remove_column :users, "exptertise"
  end
end
