class AddColumnBuzzword < ActiveRecord::Migration
  def self.up
    add_column :places, :buzzword, :string, :null => true
  end

  def self.down
    drop_column :places, :buzzword
  end
end
