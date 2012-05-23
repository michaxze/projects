class AddDaysColumsToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :monfrom, :string, :null => true
    add_column :listings, :monto, :string, :null => true
    add_column :listings, :tuefrom, :string, :null => true
    add_column :listings, :tueto, :string, :null => true
    add_column :listings, :wedfrom, :string, :null => true
    add_column :listings, :wedto, :string, :null => true
    add_column :listings, :thufrom, :string, :null => true
    add_column :listings, :thuto, :string, :null => true
    add_column :listings, :frifrom, :string, :null => true
    add_column :listings, :frito, :string, :null => true
    add_column :listings, :satfrom, :string, :null => true
    add_column :listings, :satto, :string, :null => true
    add_column :listings, :sunfrom, :string, :null => true
    add_column :listings, :sunto, :string, :null => true

    add_column :listings, :monfrompm, :string, :null => true
    add_column :listings, :montopm, :string, :null => true
    add_column :listings, :tuefrompm, :string, :null => true
    add_column :listings, :tuetopm, :string, :null => true
    add_column :listings, :wedfrompm, :string, :null => true
    add_column :listings, :wedtopm, :string, :null => true
    add_column :listings, :thufrompm, :string, :null => true
    add_column :listings, :thutopm, :string, :null => true
    add_column :listings, :frifrompm, :string, :null => true
    add_column :listings, :fritopm, :string, :null => true
    add_column :listings, :satfrompm, :string, :null => true
    add_column :listings, :sattopm, :string, :null => true
    add_column :listings, :sunfrompm, :string, :null => true
    add_column :listings, :suntopm, :string, :null => true

  end

  def self.down
  end
end
