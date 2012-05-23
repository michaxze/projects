class AddReferredEmailToMessageThreadTable < ActiveRecord::Migration
  def self.up
    add_column :message_threads, :referred_email, :string
  end

  def self.down
  end
end
