# This file is used by Rack-based servers to start the application.
#ENV['GEM_PATH'] = '/home/mgimenac/ruby/gems:/usr/lib/ruby/gems/1.8'
#ENV['GEM_HOME'] = '/home/mgimenac/ruby/gems:/usr/lib/ruby/gems/1.8'

require ::File.expand_path('../config/environment',  __FILE__)
run Kuatro::Application
