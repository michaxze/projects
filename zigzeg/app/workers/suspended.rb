class Suspended
  @queue = :suspended_queue

  def self.perform(user_id, payment=nil)
    user = User.find(user_id)

    unless user.nil?
      Mailer.suspended_notification(user).deliver
    end
  end
end
