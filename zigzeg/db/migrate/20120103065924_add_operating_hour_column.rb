class AddOperatingHourColumn < ActiveRecord::Migration
  def self.up
    add_column :places, :operation_hours, :string, :null => true
    add_column :places, :operation_times, :text, :null => true
  end

  def self.down
  end
end
