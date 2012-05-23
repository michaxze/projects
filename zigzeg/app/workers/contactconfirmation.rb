class Contactconfirmation
  @queue = :contactconfirmation_queue

  def self.perform(msg_id, user_id=nil)
    puts "Sending email to advertiser..."
    msg = Message.find(msg_id)

    user = User.find(user_id)
    Mailer.contact_confirmation_login(msg, user).deliver
  end
end
