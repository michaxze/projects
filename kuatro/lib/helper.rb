require 'rubygems'
require 'webrick'

module Helper
  def self.to_html(string)
    return "" if string.nil?
    string.gsub("\n", "<br/>")
  end

  def self.clean_desc(string)
    string.gsub!("\n", "")
  end

  def self.clean_code(name)
    return nil if name.nil?
    code = name.strip
    code = code.downcase.gsub(" & ", "-")
    code = code.gsub(" / ", "/")
    code = code.gsub(" - ", "-")
    code = code.gsub("'", "")
    code = code.gsub(",", "")
    code = code.gsub("/", "-")
    code = code.gsub(" ", "-")
    code
  end

  def self.clean_url(name)
    return "" if name.nil?
    name.gsub!(/(['"\/,;&^$%@!`~+:*#._()=])/, '')
    name.gsub!(" ", "")
    name.downcase.gsub(" ", "-")
  end

  def self.generate_username
    WEBrick::Utils.random_string(10)
  end

  def self.generate_password
    WEBrick::Utils.random_string(8)
  end

  def self.encrypt(string)
    Digest::SHA256.hexdigest(string.to_s)
  end

  def self.encrypt_password(password)
    password_string = "#{password.strip} - Th3 Ult1m4t3 F1ght3r"
    Digest::SHA256.hexdigest(password_string)
  end

  def self.generate_token(str)
    Digest::SHA1.hexdigest("#{str}:#{Time.now.to_i}")
  end

  def self.is_email?(email)
    #TODO: do more regex checking
    email.split(/@/).size > 1
  end

  def self.facebook_sharer(url, title)
    "http://www.facebook.com/sharer.php?u=#{url}&t=#{title}"
  end

  def self.twitter_sharer(url, title)
    "http://twitter.com/home?status=#{title} #{url}"
  end

end
