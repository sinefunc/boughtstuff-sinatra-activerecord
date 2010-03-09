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

require root_path('config', 'rails-compat')
require root_path('config', 'boughtstuff')
require root_path('config', 'sinefunc')
require root_path('lib', 'format')
require root_path('lib', 'item_url')
require root_path('lib', 'uuid')

I18n.backend.load_translations(root_path('config', 'locales', 'en.yml'))

alias :app_config :settings

class Main < Monk::Glue
  enable :sessions
  set    :app_file, __FILE__

  use     Rack::Session::Cookie, settings(:session)
  use     Twitter::Login, settings(:twitter)
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
