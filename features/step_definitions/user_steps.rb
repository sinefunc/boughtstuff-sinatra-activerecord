Given /^I am an anonymous user$/ do
end

Given /^I am logged in as (.+?)$/ do |fullname|
  username   = fullname.downcase.gsub(/[^a-z0-9]/, '-')
  twitter_id = Time.now.to_f * 1000

  FakeWeb.register_uri(
    :post, "http://twitter.com/oauth/request_token",
    :body => [ "oauth_token=token", 
      "oauth_token_secret=secret",
      "oauth_callback_confirmed=true" 
    ].join('&')
  )

  FakeWeb.register_uri(
    :post, "http://twitter.com/oauth/access_token",
    :body => "oauth_token=this_need_not_be_real&oauth_token_secret=same_for_this"
  )
  FakeWeb.register_uri(
    :get, "http://twitter.com/account/verify_credentials.json",
    :body => File.read(root_path('spec/fixtures/files/verify_credentials.json')).
               gsub(':screen_name', username).
               gsub(':id', twitter_id.to_s).
               gsub(':name', fullname)
  )

  visit "/login?oauth_verifier=true"

  follow_redirect!
end

Then /^show me env$/ do
end
