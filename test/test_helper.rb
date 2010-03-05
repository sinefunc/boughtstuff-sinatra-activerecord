ENV['RACK_ENV'] = 'test'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))

require "rack/test"
require "contest"
require "override"
require "quietbacktrace"

class Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    # Uncomment if you want to reset the database
    # before each test.
    # Ohm.flush
  end

  def app
    Main.new
  end

  def self.should_validate_presence_of( attribute )
    should "validate presence of #{attribute}" do
      assert_respond_to @model, attribute
      @model.send("#{attribute}=", nil)
      @model.valid?
      
      assert @model.errors.any? { |e| e.first == attribute && e.last == :not_present }
    end
  end
end
