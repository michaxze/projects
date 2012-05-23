class SmsSender < Resque::Plugins::RestrictionJob
  restrict :per_minute => 10

  @queue = :sms_handler

  def self.perform(destination, message)
    Rails.logger.info "******** Sending SMS to #{destination} ********"
    RestClient.post "#{Sms.config['sendsms']['outbound_url']}", :address => "#{destination}", :message => "#{message}"
  end
end