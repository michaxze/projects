# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#ActionController::Base.session = {
#  :key         => '_etro_session',
#  :secret      => 'eb73214f5f330cf8ba4465097f948c4d240621d6840eb3812f9680814839f619cb43828bf78a61bbf44f49b96ed839e32fb30c552bed71d2afc8c1d122fe6b7c'
#}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

session_options = {
  :key => '_etro_session',
  :session_user => Etro::SessionUser,
  :cache_expire_after => 14400,
  :cache_key_prefix => 'etro'
}

ActionController::Base.session = session_options
ActionController::Base.session_store = :couch_potato
