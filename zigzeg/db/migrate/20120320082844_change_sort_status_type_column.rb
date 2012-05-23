class ChangeSortStatusTypeColumn < ActiveRecord::Migration
  def self.up
    change_column :deals, :sort_status, :string, :default => "0", :null => true, :length => 5
  end

  def self.down
  end
end
