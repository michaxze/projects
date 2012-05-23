require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class EnvironmentTest < ActiveSupport::TestCase
  def test_success
    assert(true, "WTF?!?")
  end

  def test_boboot
    assert(defined?(Boboot), "Boboot loader not loaded properly")
  end

  def test_etro
    require 'etro'
    assert(defined?(Etro), "Etro loader not defined")
  end

  def test_palmade_gems
    assert(defined?(Palmade::DbEssentials), "Palmade::DbEssentials not defined")
    assert(defined?(Palmade::CouchPotato), "Palmade::CouchPotato not defined")
    assert(defined?(Palmade::HttpService), "Palmade::HttpService not defined")
    assert(defined?(Palmade::CandyWrapper), "Palmade::CandyWrapper not defined")
  end
end
