class CreateDailyTimes < ActiveRecord::Migration
  def change
    create_table :daily_times do |t|
      t.integer :user_id
      t.string :time_in
      t.string :time_out

      t.timestamps
    end
  end
end
