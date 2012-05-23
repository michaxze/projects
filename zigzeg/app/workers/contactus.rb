class Contactus
  @queue = :contactus_queue

  def self.perform(message_id, args = {})
    puts "Preparing to reply to contact us message..."
    msg = Message.find(message_id)
    contact_msg = Message.find(msg.parent_id)
    Mailer.reply_contactus(contact_msg.contact_email, msg).deliver
  end
end
