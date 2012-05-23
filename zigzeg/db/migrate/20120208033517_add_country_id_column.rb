class AddCountryIdColumn < ActiveRecord::Migration
  def self.up
    add_column :states, :country_id, :integer
  end

  def self.down
  end
end
