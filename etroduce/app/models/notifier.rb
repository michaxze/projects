class Notifier < ActionMailer::Base
  
  def registration_confirmation(user)
    recipients  user.email
    from        "no-reply@etroduce.com"
    subject     "Thank you for signing up at Etroduce.com"
    body        :user => user
  end

  def hello_world(sent_at = Time.now)
    subject    'Notifier#hello_world'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
