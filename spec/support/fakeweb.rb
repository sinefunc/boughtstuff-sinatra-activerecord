FakeWeb.allow_net_connect = false

Rspec.configure do |c|
  c.before(:each)  {
    FakeWeb.register_uri(:post, "http://twitter.com/statuses/update.json",
                         :body => {:id => 123145}.to_json)

  }
end
