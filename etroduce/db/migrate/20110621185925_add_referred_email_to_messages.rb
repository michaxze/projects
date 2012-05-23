class AddReferredEmailToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :referred_email, :string, :null => true
  end

  def self.down
  end
end
