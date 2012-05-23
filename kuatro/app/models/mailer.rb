class Mailer < ActionMailer::Base
  
  #default :from => "KUATROMEDYA<info@kuatromedya.com>",  :reply_to => "info@kuatromedya.com"
  default :from => "KUATROMEDYA<info@mgimena.com>",  :reply_to => "info@mgimena.com"

  def send_contactus(params)
    @params = params
    subject = "Contact us message from Kuatromedya.com"
    mail(:to => "michaxze@gmail.com", :subject => subject)
  end

end
