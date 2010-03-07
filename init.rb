ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

%W(monk/glue haml twitter/login chronic open-uri i18n
   active_support active_record mysql).each do |gem|
  print " -> requiring #{gem}... "
  require gem
  puts  "Done!"
end

puts " -> requiring config files..." 
require root_path('config', 'rails-compat')
require root_path('config', 'boughtstuff')
require root_path('config', 'sinefunc')
require root_path('lib', 'format')
require root_path('lib', 'item_url')

I18n.backend.load_translations(root_path('config', 'locales', 'en.yml'))

puts " -> initializing main."
class Main < Monk::Glue
  enable :sessions
  set    :app_file, __FILE__

  use     Rack::Session::Cookie, Boughtstuff::SESSION_OPTIONS
  use     Twitter::Login, Boughtstuff::TWITTER_LOGIN_OPTIONS
  helpers Twitter::Login::Helpers
end

ActiveRecord::Base.establish_connection(
  YAML.load_file(root_path('config', 'database.yml'))[RACK_ENV]
)
ActiveRecord::Base.logger = logger

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
