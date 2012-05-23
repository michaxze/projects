class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.integer :user_id
      t.string  :title
      t.text    :contents
      t.string  :url_link
      t.integer :announceable_id
      t.string  :announceable_type
      t.string  :announce_type, :default => 'user', :null => false
      t.date    :start_date, :null => true
      t.date    :end_date, :null => true

      t.string  :banner_file_name
      t.string  :banner_content_type
      t.integer :banner_file_size
      t.datetime :banner_updated_at
      t.timestamps
    end
    add_index :announcements, :user_id
  end

  def self.down
    drop_table :announcements
  end
end
