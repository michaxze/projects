module Sms
  def self.logger; @@logger; end
  def self.logger=(l); @@logger = l; end

  def self.rcache; @@rcache; end
  def self.rcache=(r); @@rcache = r; end

  def self.config
    if defined?(@@config)
      @@config
    else
      config_path = File.join(Rails.root, 'config/sms.yml')
      if File.exists?(config_path)
        @@config = YAML.load_file(config_path)
        @@config.freeze
        @@config
      else
        raise "Please create a config/sms.yml file, for application configs"
      end
    end
  end
end