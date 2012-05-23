ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
   :port => 587,
   :domain => "mgimena.com",
   :user_name => "mike@mgimena.com",
   :password => "superstack186**",
   :authentication => :login,
   :enable_starttls_auto => true,
   :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
}
ActionMailer::Base.default_url_options[:host] = "mgimena.com"
