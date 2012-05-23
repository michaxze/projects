class UpdatesSender
  @queue = :update_senders_queue

  def self.perform(user_id, args = {})
    user = User.find(user_id)

    unless user.nil?
      puts "sending email to: #{user.name_or_email}..."
      Mailer.update_sender(user).deliver
    else
      raise "User #{user_id} doesn't exist!"
    end
  end
end
