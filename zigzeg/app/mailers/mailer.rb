class Mailer < ActionMailer::Base
  layout "mail"

  default :from => "ZIGZEG<helper@zigzeg.com>",  :reply_to => "helper@zigzeg.com"

  def forget_password_instructions(user, confirmation)
    @to = user.email
    @user = user
    @confirmation = confirmation
    mail(:to => user.email,  :subject => "Password reset request")
  end

  def registration_confirmation(user, activation_link)
    @to = user.email
    @user = user
    @activation_link = activation_link
    mail(:to => user.email,  :subject => "Please activate your ZIGZEG account")
  end

  def registration_confirmation_payment(user, activation_link, payment)
    @to = user.email
    @user = user
    @payment = payment
    @activation_link = activation_link
    mail(:to => user.email,  :subject => "Please activate your ZIGZEG account")
  end

  def update_sender(user)
    @to = user.email
    @user = user
    @latest_listings = Listing.latest(nil, nil,5)
    mail(:to => user.email, :subject => "New updates for you on ZIGZEG")
  end

  def new_message_received(user, msg)
    @to = user.email
    @user = user
    @msg_path = business_message_url(msg)
    @latest_listings = Listing.latest(nil, nil,5)
    mail(:to => user.email, :subject => "New updates for you on ZIGZEG")
  end

  def announcements(user, msg, contents)
    @to = user.email
    @user = user
    mail(:to => user.email, :subject => msg.subject, :body => contents, :layout => false)
  end

  def reply_contactus(email, msg)
    @to = email
    mail(:to => email, :subject => msg.subject, :body => Helper.to_html(msg.contents))
  end

  def contact_message(msg)
    @to = "w.hlowe@gmail.com"
    @msg = msg
    mail(:to => @to, :subject => "New contact us message", :body => Helper.to_html(msg.contents))
  end

  #send email to advertiser when user ask a question
  def contact_confirmation_login(msg, user)
    @msg = msg
    @msg_path = business_message_url(msg)
    @latest_listings = Listing.latest(nil, nil,5)

    @to = user.email
    @user = user
    mail(:to => user.email, :subject => "New updates for you on ZIGZEG")
  end

  def contact_confirmation_notlogin(email, name)
    @to = email
    @email = email
    @name = name rescue ''
    mail(:to => email, :subject => "Contact us Confirmation Message")
  end

  def suspended_notification(user)
    @to = user.email
    @user = user
    mail(:to => user.email, :subject => "Your ZIGZEG User account has been suspended.")
  end
  
  def contact_admin(message_hash)
    @to = "w.hlowe@gmail.com"
    @msg = message_hash
    mail(:to => @to, :subject => "Contact us form - #{message_hash[:type]}")
  end

  def notify_admin(to, msg, subj)
    mail(:to => to, :subject =>  subj, :body => msg)
  end
end
