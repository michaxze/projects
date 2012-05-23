class AddColumsnToAlerts < ActiveRecord::Migration
  def self.up
    add_column :alerts, :reportable_id, :integer
    add_column :alerts, :reportable_type, :string
  end

  def self.down
    drop_column :alerts, :reportable_id
    drop_column :alerts, :reportable_type
  end
end
