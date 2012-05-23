class Social < ActiveRecord::Base
  belongs_to :user

  serialize :info
  serialize :credentials
  serialize :extra

  class << self
    def create_new(auth, user, provider)
      case provider
      when "twitter"
        integ = Social.new
        integ.user = user
        integ.provider = provider
        integ.uid = auth["uid"]
        integ.info = auth["info"]
        integ.credentials = auth["credentials"]
        integ.extra = auth["extra"]["access_token"]
        integ.save!
      when "facebook"
        integ = Social.new
        integ.user = user
        integ.provider = provider
        integ.uid = auth["uid"]
        integ.info = auth["info"]
        integ.credentials = nil
        integ.extra = auth["extra"]["raw_info"]
        integ.save!
      end
    end
  end
end
