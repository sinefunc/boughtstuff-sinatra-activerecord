require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

Rspec.configure do |c|
  c.before(:each) {
    DatabaseCleaner.clean
  }
end

