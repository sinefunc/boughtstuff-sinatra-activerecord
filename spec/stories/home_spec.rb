require 'spec_helper'

class Twitter::Login 
  def call( env )
    if env["PATH_INFO"] == '/login'
      env["rack.session"] ||= { 
        "twitter_user" => { 
          "screen_name" => 'cyx', "twitter_id" => 1001 
        }
      }
    
      ["302", {'Location' => '/authenticated', 'Content-type' => 'text/plain'}, []]
    else
      @app.call(env)
    end
  end
end

story "As a visitor I want to get a feel for boughtstuff so I'll see what it's for" do
  scenario "A visitor going to the homepage" do
    given do
      visit "/"
    end

    it { should contain("Login to Twitter") }
  end
  

  scenario "A visitor trying to login via twitter" do
    given do
      visit "/"

      click_link "Login to Twitter"
    end
  
    it { puts (@_rack_mock_sessions[:default].methods - Object.methods).inspect }
    it { puts instance_variables.inspect }
    it { puts debug_response }
  end
end
