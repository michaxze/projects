class DailyTime < ActiveRecord::Base
  
  class << self
    def for_month(user, time)
      where("user_id = ? AND DATE_FORMAT(created_at, '%Y-%m') = ?", user.id, time.strftime("%Y-%m")).
      order("created_at ASC")
    end
    
    def record_time(user, timein, timeout)
      time = Time.now
      rec = DailyTime.where("user_id = ? AND DATE_FORMAT(created_at, '%Y-%m-%d') = ?", user.id, time.strftime("%Y-%m-%d")).first
      rec = rec || DailyTime.new
      
      rec.user_id = user.id
      rec.time_in = timein unless timein.nil?
      rec.time_out = timeout unless timeout.nil?
      rec.save!
    end
  end
end
