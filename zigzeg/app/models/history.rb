class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing

  scope :recent, where("created_at >= ?", 5.days.ago).group("listing_id"). order("updated_at DESC")
  scope :two_weeks_ago, lambda { where("created_at > ?", 2.week.ago ) }
  scope :month_ago, lambda { where("created_at > ?", 1.month.ago ) }

  class << self

    #unique record per day history
    def create_history(user, listing)
      histories = History.find(:all, :conditions => ["user_id = ? AND listing_id = ? AND DATE_FORMAT(created_at, '%Y-%m-%d')  = ?", user.id, listing.id, Time.now.to_date])

      histories.each do |h|
        h.created_at = Time.now.to_date
        h.updated_at = Time.now
        h.save!
      end

      if histories.empty?
        History.create!(:user => user, :listing => listing)
      end
    end
  end
end
