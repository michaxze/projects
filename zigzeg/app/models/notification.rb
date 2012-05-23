class Notification < ActiveRecord::Base
  belongs_to :user

  scope :latest, lambda{
    where("created_at > ?", 5.days.ago)
  }

  class << self
    def random_row(user, last_id=nil)
      notes = case user.user_type.to_s
        when Constant::REGULAR
          Notification.where("show_type IN (?)", [Constant::REGULAR, Constant::BOTH])
        when Constant::ADVERTISER
          Notification.where("show_type IN (?)", [Constant::ADVERTISER, Constant::BOTH])
        else
          []
        end
      return nil if notes.empty?

      unless last_id.nil?
        ids = notes.map(&:id)
        index = ids.find_index(last_id.to_i) ? (ids.find_index(last_id.to_i) + 1) : 0
        note = Notification.find(ids[index]) rescue nil
        unless note.nil?
          return note
        else
          return notes.first
        end
      end

      return notes.first
    end
  end
end
