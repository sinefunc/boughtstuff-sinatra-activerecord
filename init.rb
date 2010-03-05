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
require ROOT_DIR + '/lib/uuid'

class Main < Monk::Glue
  enable :sessions
  set :app_file, __FILE__
  use Rack::Session::Cookie
  use Twitter::Login, 
    consumer_key: "2YTK8XIszlR12aVju0tA", 
    secret:       "lcO2ulMC2dhAS1dvEQz7qT4fCsMFKDrqpF9BSyw2A8"
end

# Connect to redis database.
Ohm.connect(settings(:redis))

# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?
