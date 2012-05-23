module Etro
  # default random secret expiration, is 2 hrs
  RANDOM_SECRET_EXPIRE_LIMIT = (2 * 60 * 60).freeze
  RANDOM_SECRET_KEY_PREFIX = "etroduce/random_secret".freeze
  USERKEY_FORMAT = "%04x%04x%04x%06x%06x%s".freeze

  COUNTRIES = [
    ["Korea", "KR"],
    ["Philippines", "PH"],
    ["United States of America","US"]
  ]
  
  LANGUAGES = [
                "english",
                "korean"
              ].collect(&:freeze)

  RESERVED_USERNAMES = [
                        # controllers
                        "users",
                        "application",
                        "invitations",
                        "opportunities",
                        "contacts",
                        "contact_lists",
                        "contacts_list",
                        "etros",
                        "messages",
                        "mthreads",
                        "pages",
                        "profiles",
                        "tags",
                        "user_networks",
                        "user_numbers",
                        "work_infos",
                        "sessions",
                        "admin",
                        "bizsp",
                        "getting_started",
                        "notifications",
                        "classifieds",

                        # special routes
                        "sign_in",
                        "sign_out",
                        "confirm",
                        "tw_callback",
                        "dashboard",
                        "my_contacts",
                        "search",
                        "alpha",
                        "beta",
                        "sign",
                        "out",
                        "terms",
                        "privacy",
                        "facebook",
                        "linkedin",
                        "twitter",
                        "link",
                        "start",
                        "jobs",

                        # reserved usernames
                        "admin",
                        "superuser",
                        "root"
                       ].collect(&:freeze)

  # only alpha-numeric characters, and underscore, and min of 4, max 16
  USERNAME_CHARS = "[a-zA-z][a-zA-Z0-9_]{3,15}".freeze
  ALLOWED_USERNAME_REGEX = /\A#{USERNAME_CHARS}\Z/i.freeze
  URL_USERNAME_REGEX = /#{USERNAME_CHARS}/i.freeze

  # allowed opportunity short code is the same as usernames
  SHORTCODE_CHARS = "[a-zA-z][a-zA-Z0-9_-]{3,15}".freeze
  ALLOWED_SHORTCODE_REGEX = /\A#{SHORTCODE_CHARS}\Z/i.freeze
  URL_SHORTCODE_REGEX = /#{SHORTCODE_CHARS}/i.freeze

  PRIVACY_LEVELS_OPTIONS = [
    ["Public", 3],
    ["Friend of friends", 2],
    ["Friends Only", 1]
  ]

  POST_TYPES = [
    ["Personal post", "personal"],
    ["Business post", "business"]
  ]

  PRIVACY_LEVELS = {
    :private => 0,

    # first degree contacts
    :first => 1,

    # second degree contacts
    :second => 2,

    # everyone can see it
    :public => 3
  }

  NOTIFICATIONS_ACTION = {
    :accept_invitation => 'accept',
    :message => 'message',
    :etro_request => 'etro_request',
    :etro_request_approved => 'etro_request_approved',
    :etro_notice => 'etro_notice',
    :etro_message => 'etro_message',
    :comment => 'comment',
    :contact_request => 'contact_request'
  }

  REFERRAL_STATUS = {
    :accepted => 1
  }

  VALID_NETWORKS = %w(gmail yahoo facebook twitter linkedin)

  OPPORTUNITY_LIMIT_PER_COLUMN = 6

  def self.default_privacy
    PRIVACY_LEVELS[:second]
  end

  def self.logger; @@logger; end
  def self.logger=(l); @@logger = l; end

  def self.rcache; @@rcache; end
  def self.rcache=(r); @@rcache = r; end

  def self.rcache_durable=(r); @@rcache_durable = r; end
  def self.rcache_durable; @@rcache_durable; end

  def self.config
    if defined?(@@config)
      @@config
    else
      config_path = File.join(Rails.root, 'config/etro.yml')
      if File.exists?(config_path)
        @@config = YAML.load_file(config_path)
        @@config.freeze
        @@config
      else
        raise "Please create a config/etro.yml file, for application configs"
      end
    end
  end

  def self.from_email
    if defined?(@@from_email)
      @@from_email
    else
      @@from_email = config['from_email']
    end
  end

  def self.base_url
    if defined?(@@base_url)
      @@base_url
    else
      @@base_url = URI.parse(config['base_url'])
    end
  end

  def self.create_url(path, params = nil)
    url = File.join(base_url.to_s, path)
    unless params.nil?
      url += "?#{Utils.query_string(params)}"
    end
    url
  end

  def self.random_secret_expire_limit
    RANDOM_SECRET_EXPIRE_LIMIT
  end

  def self.generate_random_secret(len = 6)
    len.times.collect { Random.new.rand(0..9).to_s }.join
  end

  def self.get_or_create_random_secret(u, tm = nil)
    email = u.email
    tm = random_secret_expire_limit if tm.nil?

    secret_key = [ RANDOM_SECRET_KEY_PREFIX, email ].join('/')
    if rcache.exists(secret_key)
      rs = rcache.get(secret_key)
    else
      rs = generate_random_secret
    end

    rcache.set(secret_key, rs)
    rcache.expire(secret_key, tm)

    rs
  end

  def self.generate_userkey
    srand(Time.now.usec)

    Digest::MD5.hexdigest(USERKEY_FORMAT %
                          [
                           rand(0x0010000),
                           rand(0x0010000),
                           rand(0x0010000),
                           rand(0x1000000),
                           rand(0x1000000),
                           String(Time::now.usec)
                          ]).freeze
  end

  def self.generate_token(key)
    Digest::SHA256.hexdigest(key)
  end

  CRandomPassChars = %w(b c d f g h j k m 2 n p q u r s 3 t v w x z 4 c h c r f r n d n g 5 n k 6 n t p 6 h p 4 r r 7 d 3 s h 8 s s 9 p s 2 t t h t r).freeze
  CRandomPassVowels = %w(a 2 e 4 i 6 8 u y 3).freeze

  # Generate readable random password
  #
  # == Parameters
  # :len:
  #   Len of the password to generate, default: 8
  #
  # == Returns
  # Return a random password of given length +len+
  #
  def self.generate_random_password(len = 8)
    f, r = true, ''
    len.times do
      r << (f ? CRandomPassChars[Random.new.rand(0...CRandomPassChars.size)] :
            CRandomPassVowels[Random.new.rand(0...CRandomPassVowels.size)])
      f = !f
    end
    r
  end

  #CRandomPassChars = %w(b c d f g h j k m 2 n p q u r s 3 t v w x z 4 c h c r f r n d n g 5 n k 6 n t p 6 h p 4 r r 7 d 3 s h 8 s s 9 p s 2 t t h t r).freeze
  #CRandomPassVowels = %w(a 2 e 4 i 6 8 u y 3).freeze

  CRandomSCAlpha = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  CRandomSCAlphaNum = %w(a b 1 c d 2 e f 3 g h 4 i j 5 k l 6 m n 7 o p 8 q r 9 s t 0 u v w x y z)
  # :TODO:
  #   make sure that this is 100% unique
  #
  def self.generate_short_code(len = 8)
    f, r = true, ''
    len.times do
      r << (f ? CRandomSCAlpha[Random.new.rand(0...CRandomSCAlpha.size)] : CRandomSCAlphaNum[Random.new.rand(0...CRandomSCAlphaNum.size)] )

      f = !f
    end
    r
  end
end
