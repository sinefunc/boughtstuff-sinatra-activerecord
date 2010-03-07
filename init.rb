ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "ohm"
require "haml"
require "sass"
require "twitter/login"
require "chronic"
require "i18n"
require "active_support"
require root_path('lib', 'uuid')
require root_path('config', 'boughtstuff')

# == Make sure we set Sinatra::Application.public first ==
# == before we load carrier wave ==
Sinatra::Application.public = root_path('public')

require "carrierwave"

class Main < Monk::Glue
  enable :sessions
  set    :app_file, __FILE__

  use     Rack::Session::Cookie, Boughtstuff::SESSION_OPTIONS
  use     Twitter::Login, Boughtstuff::TWITTER_LOGIN_OPTIONS
  helpers Twitter::Login::Helpers
end

# Connect to redis database.
Ohm.connect(settings(:redis))

# Load all application files.
class Object
  Dir[root_path("app/models/*.rb")].each do |file|
    autoload File.basename(file, '.rb').camelize, file
  end
end

Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?
