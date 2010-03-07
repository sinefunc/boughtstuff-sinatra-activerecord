Rspec.configure do |c|
  c.before(:each) do 
    port = 6380
    
    `redis-cli -p #{port} flushdb`
  end
end
