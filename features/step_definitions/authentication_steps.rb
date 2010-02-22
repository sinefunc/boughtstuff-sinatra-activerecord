Given /^I am logged in as (.*?)$/ do |user|
  u = User.new
  u.login = user
  u.twitter_id = "1001"
  u.remember_token = 'ba68fbb74520afb4eb6d'
  u.remember_token_expires_at = '2010-03-07 15:20:51'
  u.save!
  
  User.stub!(:authenticate).and_return(u)
  post '/session', { :username => user, :password => 'foobar' }
end
