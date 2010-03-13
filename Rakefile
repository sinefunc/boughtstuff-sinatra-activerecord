task :environment do
  require 'init'
end

load 'lib/tasks/database.rake'

desc "Generate a .gems manifest file for use with heroku"
task :create_heroku_gems_manifest do
  skip = %w(factory_girl database_cleaner daemons eventmachine faker
            fakeweb fastthread gemcutter json json_pure linecache19 
            mysql sqlite3-ruby nokogiri rack rack-test rake
            rspec-core rspec rspec-expectations rspec-mocks 
            rspec-rails-matchers ruby-debug-base19 ruby-debug19
            thin timecop webrat ZenTest)

  rvm_gems = File.read("config/rvm.gems").split("\n")
  
  File.open('.gems', 'w') do |f|
    rvm_gems.each do |gem|
      name, version = gem.split(" -v")

      next if gem.index('#') == 0
      next if skip.include?(name)

      f.write "#{name} --version #{version}\n"
    end
  end
  
  puts " => Created .gems"
  puts File.read('.gems')
end
