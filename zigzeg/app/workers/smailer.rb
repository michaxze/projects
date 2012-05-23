class Smailer
  @queue = :mails_queue

  def self.perform(message_id, args = {})
    msg = Message.find(message_id)

    unless msg.nil?
      puts "sending email to: #{msg.receiver.fullname}(#{msg.receiver.username})..."
      Mailer.new_message_received(msg.receiver, msg).deliver
    else
      raise "Message #{msg.id} doesn't exist!"
    end
  end
end
