# encoding: utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../')); $:.uniq!
require 'test_helper'
require 'api'

class I18nFastBackendApiTest < Test::Unit::TestCase
  include Tests::Api::Basics
  include Tests::Api::Defaults
  include Tests::Api::Interpolation
  include Tests::Api::Link
  include Tests::Api::Lookup
  include Tests::Api::Pluralization
  include Tests::Api::Procs
  include Tests::Api::Localization::Date
  include Tests::Api::Localization::DateTime
  include Tests::Api::Localization::Time
  include Tests::Api::Localization::Procs
  
  class FastBackend
    include I18n::Backend::Base
    include I18n::Backend::Fast
  end

  def setup
    I18n.backend = FastBackend.new
    super
  end
  
  test "make sure we use the FastBackend backend" do
    assert_equal FastBackend, I18n.backend.class
  end
end