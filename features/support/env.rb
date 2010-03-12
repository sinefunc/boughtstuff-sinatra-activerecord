require File.join(File.dirname(__FILE__), *%w[.. .. spec spec_helper.rb])

require 'rspec/expectations'
require 'rack/test'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

class RackTestWithWebratWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  include Rspec::Expectations

  # Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Main.new
  end

  def response
    @_rack_test_sessions[:default].last_response
  end
end

World{RackTestWithWebratWorld.new}

