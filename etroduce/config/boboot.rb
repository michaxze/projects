require 'rubygems'

ROOT_PATH = ETRODUCE_ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))

### Extensions for bundler

begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old for Rails 2.3." +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run bundle install?"
end

module Boboot
  def self.root_path; ROOT_PATH; end

  def self.require_relative_gem(gem_name, lib_path)
    require File.join(self.root_path, '..', gem_name, 'lib', lib_path)
  end

  def self.boot_rails!(env = nil)
    if env.nil?
      if ENV.include?('RAILS_ENV')
        Object.const_set('RAILS_ENV', ENV['RAILS_ENV'])
      else
        Object.const_set('RAILS_ENV', 'development')
      end
    else
      Object.const_set('RAILS_ENV', env)
    end

    require File.join(self.root_path, 'config/environment')
  end
end
