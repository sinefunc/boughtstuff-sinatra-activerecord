# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_boughtstuff_session',
  :secret      => '097d0f233c0f42d0ffa6d7ed5df45fecbb41aa48fad0456c6cb60727a0e48fc7acf3f9388799054718419937e83c35cc9a5b432751cdb0c67b03c2606f29b003'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
