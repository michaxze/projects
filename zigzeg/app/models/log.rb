class Log < ActiveRecord::Base
  serialize :params

  class << self
    def create(location, request, user, params)
      log = Log.new(:location => location)
      log.content = params[:q] unless params.nil?
      log.params = params unless params.nil?
      log.user_id = user.id unless user.nil?
      log.url = request.url
      log.user_agent = request.user_agent
      log.ip = request.remote_ip
      log.save!
    end
  end
end
