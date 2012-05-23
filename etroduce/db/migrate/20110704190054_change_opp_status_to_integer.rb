class ChangeOppStatusToInteger < ActiveRecord::Migration
  def self.up
    change_column :opportunities, :status, :integer
  end

  def self.down
  end
end
