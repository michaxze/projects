class UserMailer < ActionMailer::Base

  def contactus(to, params)
    recipients  to
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     "Message from Contact us form - Etroduce.com"
    body        :params => params
  end
  
  def registration_confirmation(user, link)
    recipients  user.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     "Thank you for signing up at Etroduce.com"
    body        :user => user, :activation_link => link
  end  
  def send_request(user, invitation, confirm_link)
    recipients  invitation.email
    from        "#{user.fullname.titleize} <#{user.email}>"
    subject     "Please join my network at Etroduce.com"
    body        :user => user, :invitation => invitation, :confirm_link => confirm_link
  end
  
  def confirm_network_owner(invitation)
    recipients  invitation.user.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     "Your friend #{invitation.fullname.titleize} have successfully joined your network at Etroduce.com"
    body        :invitation => invitation
  end
  
  def forget_password(user)
    recipients  user.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     "Change password for Etroduce.com"
    body        :user => user
  end

  def send_invite_na(receiver, activate_link, params)
    recipients receiver.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     params[:subject]
    body        :receiver => receiver, :activate_link => activate_link
  end
  
  def send_respond(sender, receiver, message, params)
    recipients receiver.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     params[:subject]
    body        :sender => sender, :receiver => receiver, :mesg => params[:message], :link => params[:mlink]
  end
  
  def send_message(sender, receiver, params)
    recipients receiver.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     params[:subject]
    body        :message => params[:message], :link => params[:link]
  end

  def send_refer(sender, opp, message, params)
    recipients opp.user.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     params[:subject]
    body        :sender => sender, :opp => opp, :mesg => params[:message], :link => params[:mlink]
  end

  def send_reply(sender, receiver, message)
    recipients receiver.email
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     "#{sender.fullname.titleize} sent you a message."
    body        :sender => sender, :receiver => receiver, :message => message
  end

  def notify_newpost(sender, receiver, opp, link)
    recipients  receiver.email
    from        "Etroduce<support@etroduce.com>"
    subject     "Etroduce - New opportunity posted."
    body        :sender => sender, :receiver => receiver, :opp => opp, :link => link
  end
  
  def notify_admin(type='new_post', new_object, url)
    recipients "john@hcapnet.com"
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    subject     "New post created."
    body        :obj => new_object, :url => url
  end
  
  def send_forgot_password(user, link)
    recipients user.email
    subject     "Reset your Etroduce password"
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"    
    body        :user => user, :link => link
  end
  
  def accepted_invitation(sender, receiver)
    recipients  receiver.email
    subject     "#{sender.fullname.titleize} has accepted your invitation."
    from        "Jonas Andrews, Etroduce.com<support@etroduce.com>"
    body        :sender => sender, :receiver => receiver
  end

end