class AddSortStatusColumn < ActiveRecord::Migration
  def self.up
    add_column :events, :sort_status, :integer, :default => 0
    add_column :deals, :sort_status, :integer, :default => 0
  end

  def self.down
  end
end
