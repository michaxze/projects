yaml_file = File.expand_path('../../faye.yml', __FILE__)
yaml_env = ENV["RAILS_ENV"] || "development"

yaml_config = YAML.load_file(yaml_file)[yaml_env]
raise ArgumentError, "The #{yaml_env} environment does not exist in #{yaml_file}" if yaml_config.nil?

::FAYE_CONFIG = {}
yaml_config.each { |k, v| ::FAYE_CONFIG[k.to_sym] = v }
