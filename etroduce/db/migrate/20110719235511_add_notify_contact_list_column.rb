class AddNotifyContactListColumn < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :notify_contact_list, :string, :null => true
  end

  def self.down
  end
end
