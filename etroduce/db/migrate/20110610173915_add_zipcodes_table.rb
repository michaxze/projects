class AddZipcodesTable < ActiveRecord::Migration
  def self.up
    create_table :zipcodes, :force => true do |t|
      t.string :code
      t.string :city
    end
    add_index :zipcodes, :code
  end

  def self.down
    drop_table :zipcodes
  end
end
