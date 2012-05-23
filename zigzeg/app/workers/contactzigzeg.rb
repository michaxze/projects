class Contactzigzeg
  @queue = :contactzigzeg_queue

  def self.perform(message_id, args = {})
    puts "Sending email to administrator..."
    msg = Message.find(message_id)
    Mailer.contact_message(msg).deliver
  end
end
