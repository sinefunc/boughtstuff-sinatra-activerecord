ENV['RACK_ENV'] = 'test'

require 'init'
require 'rspec'
require 'timecop'

Dir[ 'spec/support/*.rb' ].each { |f| require f }
