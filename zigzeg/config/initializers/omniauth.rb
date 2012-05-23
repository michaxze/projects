#require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '123123',''
  provider :twitter, '',''
end

