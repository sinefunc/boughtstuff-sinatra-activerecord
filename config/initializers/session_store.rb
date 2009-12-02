# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_boughtstuff.com_session',
  :secret      => '395b2b4acf924fc6642c64a41d4c45c5b49e740f3970cfe243c801d3b3fdab94a7388d84bc1f03e3db40c95080ad04c03390123e3c899261fcc9733df05d075f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
