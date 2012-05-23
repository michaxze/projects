class Announcer
  @queue = :annoucements_queue

  def self.perform(message_id, args = {})
    puts "Preparing to send announcement to the users..."
    msg = Message.find(message_id)

    unless args["notify"].nil?

      if args["notify"] == "advertiser"
        users = User.get_users('advertiser')
      elsif args["notify"] == "reglar"
        users = User.get_users('regular')
      else
        users = User.where("user_type IN ('advertiser', 'regular')")
      end

      users.each do |u|
        puts "Sending to #{msg.receiver.fullname} ..."
        unless msg.email_template.nil?
          contents = msg.email_template.contents
        else
          contents = Helper.to_html(msg.contents)
        end
        Mailer.announcements(msg.receiver, msg, contents).deliver
      end
    end

  end
end
