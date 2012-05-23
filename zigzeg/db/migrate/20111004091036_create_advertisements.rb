class CreateAdvertisements < ActiveRecord::Migration
  def self.up
    create_table :advertisements do |t|
      t.integer  :advertiser_id
      t.string   :advertiser_type
      t.integer  :views
      t.string   :landing_url
      t.integer  :creator_id
      t.string   :creator_type
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :advertisements
  end
end
