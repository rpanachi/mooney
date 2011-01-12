# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mooney_old_session',
  :secret      => 'db9f5593f81bc30769db84024cf2ce334ce1bff056b0a44f75311597de573a632115dbe346dd2d363bcf04abd6b2a990eeb8e9437cb9827bde5a1c309fb71be0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
