ENV['RACK_ENV'] = 'test'

require 'init' unless defined?(ROOT_DIR)
require 'rspec'
require 'timecop'
require 'rspec-rails-matchers'
require 'fakeweb'
require 'rack/test'

Dir[ 'spec/support/*.rb' ].each { |f| require f }

Rspec.configure do |config|
  require 'rspec/expectations'
  config.include Rspec::Matchers
  config.mock_with :rspec
end
