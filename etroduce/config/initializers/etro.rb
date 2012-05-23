require 'yajl'

if Etro.config.include?('rcache')
  Palmade::CouchPotato.sessions_cache = r = Redis.new(Etro.config['rcache'])
  unless Rails.env == 'production'
    r.client.logger = Rails.logger
  end

  Etro.rcache = r
else
  raise "No redis configuration found. Please set in config/etro.yml"
end
