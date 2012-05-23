class AddPublishedAtDate < ActiveRecord::Migration
  def self.up
    add_column :listings, :published_at, :datetime
  end

  def self.down
  end
end
