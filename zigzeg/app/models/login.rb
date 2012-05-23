class Login < ActiveRecord::Base

  class << self
    def create_new(email, ip)
      log = Login.new
      log.username = email
      log.ipaddress = ip
      log.save!
    end
  end
end
