ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require 'monk/glue'
require 'json'
require 'haml'
require 'twitter/login'
require 'chronic'
require 'open-uri'
require 'i18n'
require 'active_support'
require 'active_record'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'mysql'

CarrierWave.configure do |c|
  c.root = root_path('public')
  c.store_dir = root_path('public', 'system', 'uploads')
  c.cache_dir = root_path('public', 'system', 'uploads', 'tmp')
end

require root_path('config', 'rails-compat')
require root_path('config', 'boughtstuff')
require root_path('config', 'sinefunc')
require root_path('lib', 'format')
require root_path('lib', 'item_url')
require root_path('lib', 'uuid')

I18n.backend.load_translations(root_path('config', 'locales', 'en.yml'))

class Main < Monk::Glue
  enable :sessions
  set    :app_file, __FILE__

  use     Rack::Session::Cookie, Boughtstuff::SESSION_OPTIONS
  use     Twitter::Login, Boughtstuff::TWITTER_LOGIN_OPTIONS
  helpers Twitter::Login::Helpers
  helpers WillPaginate::ViewHelpers::Base
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
