class Regmailer
  @queue = :registration_queue

  def self.perform(confirmation_id, payment=nil)
    conf = Confirmation.find(confirmation_id)

    unless conf.nil?
      activation_link = "#{Yetting.domain}/confirm?token=#{conf.token}"

      unless payment.nil?
        Mailer.registration_confirmation_payment(conf.confirmable, activation_link, payment).deliver
      else
        Mailer.registration_confirmation(conf.confirmable, activation_link).deliver
      end
    else
      raise "Confirmation doesn't exist!"
    end
  end
end
