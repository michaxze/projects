class SmsHandler

  # INVITE 09391751515 mike programmer
  def self.understand(inbound_sms)
    msg = inbound_sms.message.split(",")

    case msg[0].downcase      
    when "invite"
      sender = User.find_by_mobilenumber(inbound_sms.destination_address) rescue nil
      unless sender.nil?
        destination = msg[1]
        message = "Hi #{msg[2].titleize}, #{sender.fullname.titleize} has invited you to be his contact at Etroduce.com. Reply /accept to accept his invitation."
        QUEUE.enqueue(SmsSender, destination, message)
      end
    when "accept"
      #TODO
      destination = inbound_sms.destination_address
      message = "Sorry we still have to work on this."
      QUEUE.enqueue(SmsSender, destination, message)      
    when "list"
      #TODO
      # list <search string> <location> <page>
      # list cars cebu
      destination = inbound_sms.destination_address
      message = "Sorry we still have to work on this."
      QUEUE.enqueue(SmsSender, destination, message)
    end
    
  end
end