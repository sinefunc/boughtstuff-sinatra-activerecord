# module Stories
#   module StoryMethods
#     def story(*args, &block); describe(*args, &block) end
#   end
# 
#   module ScenarioMethods
#     def scenario(*args, &block); describe(*args, &block) end
#     def given(&block); before(:each, &block) end
#   end
# 
#   module Support
#     def app
#       @app ||= Main.new
#     end
# 
#     def response
#       @_rack_test_sessions[:default].last_response
#     end
# 
#     def subject; response; end
# 
#     def debug_response
#       @document = Webrat::XML.document(response)
#       @element = @document.inner_text
#       @element.gsub(/^\s*$/, "").squeeze("\n")
#     end
#   end
# end
# 
# require 'webrat'
# $LOAD_PATH.unshift(root_path('spec', 'vendor'))
# require 'webrat/rspec_2_matchers'
# 
# Webrat.configure do |config|
#   config.mode = :rack
# end
# 
# Rspec.configure do |c| 
#   c.extend  Stories::ScenarioMethods
#   c.include Stories::Support
#   c.include Rack::Test::Methods
#   c.include Webrat::Methods
#   c.include Webrat::Rspec2Matchers
# end
# 
# extend Stories::StoryMethods
