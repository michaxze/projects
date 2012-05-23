require 'rubygems'
require 'geokit'
require 'webrick'

module Helper

  def self.generate_username
    WEBrick::Utils.random_string(10)
  end
  
  def self.generate_password
    WEBrick::Utils.random_string(8)
  end
  
  def self.encrypt_password(password, salt)
    password_string = "#{password} - #{salt} - the sentinels"
    Digest::SHA1.hexdigest(password_string)
  end

  def self.generate_token
    Digest::SHA1.hexdigest(Time.now.to_s)
  end
  
  def self.is_email(email)
    email.split(/@/).size > 1
  end
  
  def self.getcity(zipcode)
    geo = Geokit::Geocoders::GoogleGeocoder.geocode("#{zipcode}") rescue nil
    unless geo.nil?
      geo.city.to_s rescue ''
    else
      ''
    end
  end

  def self.facebook_sharer(url, title)
    "http://www.facebook.com/sharer.php?u=#{url}&t=#{title}"
  end
  
  def self.twitter_sharer(url, title)
    "http://twitter.com/home?status=#{title} #{url}"
  end
   
end
