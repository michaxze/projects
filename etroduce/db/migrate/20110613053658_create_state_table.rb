class CreateStateTable < ActiveRecord::Migration
  def self.up
    create_table :states, :force => true do |f|
      f.string :code
      f.string :name
    end
  end

  def self.down
    drop_table :states
  end
end
