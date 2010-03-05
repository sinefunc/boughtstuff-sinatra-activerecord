$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../rspec-monk/lib')

require 'rspec-monk'
require 'rspec-monk/ohm/matchers'
require 'rspec-monk/dsl/its'

Rspec.configure do |c|
  c.include RspecMonk::Ohm::Matchers
  c.extend  RspecMonk::Dsl::Its
end
