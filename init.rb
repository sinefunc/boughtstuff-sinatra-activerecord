ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR
$LOAD_PATH.unshift(ROOT_DIR + '/vendor/monk-glue/lib')

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
require 'lilypad'

begin
  require 'mysql'
rescue LoadError
  require 'pg'
rescue LoadError
  require 'sqlite3-ruby'
end

Dir[ root_path('config', 'initializers', '*.rb') ].each { |f| require f }

class Main < Monk::Glue
  enable :sessions
  set    :app_file, __FILE__

  use     Rack::Session::Cookie, settings(:session)
  use     Twitter::Login, settings(:twitter)
  use     Rack::Lilypad do
    api_key "cc8aa796ba335d9f24549349214a6c32"
    sinatra
  end

  helpers Twitter::Login::Helpers
  helpers WillPaginate::ViewHelpers::Base
 

  configure :development do
    enable :show_exceptions
    enable :reload_templates
  end

  not_found do
    haml :'404'
  end
  
  error ActiveRecord::RecordNotFound do
    haml :'404'    
  end

  unless show_exceptions
    error do
      haml :'500'
    end
  end
end

Dir[ root_path('lib/*.rb') ].each { |file| require file }

Dir[ root_path('app/concerns/*.rb'), root_path('app/models/*.rb'), root_path('app/uploaders/*.rb') ].each do |file|
  Object.autoload File.basename(file, '.rb').camelize, file
end

Dir[root_path('app/routes/*.rb'), root_path('app/helpers/*.rb')].each do |file|
  require file
end

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?
