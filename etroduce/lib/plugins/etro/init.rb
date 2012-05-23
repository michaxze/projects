gem 'db_essentials'
require 'palmade/db_essentials'
Palmade::DbEssentials.boot!(Rails.logger)
Palmade::DbEssentials::Helpers::ActiveRecord2Helper.setup(Rails.configuration)

gem 'couch_potato'
require 'palmade/couch_potato'
Palmade::CouchPotato.boot!(Rails.logger)
Palmade::CouchPotato::Helpers::Rails2Helper.setup(Rails.configuration)

gem 'http_service'
require 'palmade/http_service'
Palmade::HttpService.logger = Rails.logger

gem 'candy_wrapper'
require 'palmade/candy_wrapper'
Palmade::CandyWrapper.logger = Rails.logger
