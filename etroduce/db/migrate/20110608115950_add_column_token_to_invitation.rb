class AddColumnTokenToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, "token", :string
    add_column :invitations, "expertise", :string
  end

  def self.down
    remove_column :invitations, "token"
    remove_column :invitations, "expertise"
  end
end
