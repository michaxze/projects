class AddPricingTypeColumn < ActiveRecord::Migration
  def self.up
    add_column :events, :pricing_type, :string, :default => "free"
    add_column :events, :event_day, :string, :default => nil, :null => true
    change_column :events, :event_type, :string, :default => nil, :null => true
  end

  def self.down
  end
end
