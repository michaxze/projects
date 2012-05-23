class AddCountryCodeColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :country_code, :string
    add_column :opportunities, :subdomain, :string
  end

  def self.down
  end
end
