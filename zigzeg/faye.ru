require 'yaml'
require 'faye'
#require File.expand_path('../config/initializers/faye.rb', __FILE__)

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != "a66aaf508baf67c49a344418479675b2"
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call(message)
  end
end

faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45)
faye_server.add_extension(ServerAuth.new)
run faye_server
