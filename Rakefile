task :environment do
  require 'init'
end

load 'lib/tasks/database.rake'

desc "Generate a .gems manifest file for use with heroku"
task :create_heroku_gems_manifest do
  skip = %w(factory_girl database_cleaner daemons eventmachine faker
            fakeweb fastthread gemcutter json_pure linecache19 
            mysql sqlite3-ruby nokogiri rspec-core rspec rspec-expectations 
            rspec-mocks rspec-rails-matchers ruby-debug-base19 ruby-debug19
            thin timecop webrat ZenTest treetop cucumber term-ansicolor
            polyglot image_science RubyInline heroku configuration
            launchy)
  
  deps = %w(tzinfo builder memcache-client rack rack-test rack-mount 
            erubis mail text-format thor bundler i18n)

  rvm_gems = File.read("config/rvm.gems").split("\n")
  
  gems = []
  rvm_gems.each do |gem|
    name, version = gem.split(" -v")
    
    next if gem.index('#') == 0
    next if skip.include?(name)
    
    if deps.include?(name)
      gems.unshift([name, version])
    else
      gems << [ name, version ]
    end
  end
  
  File.open('.gems', 'w') do |f|
    gems.each do |name, version|
      f.write "#{name} --version #{version}\n"
    end
  end
  
  puts " => Created .gems"
  puts File.read('.gems')
end

desc "Deploy to heroku"
task :deploy => :create_heroku_gems_manifest do
  `cp .git/config .gitgithub`
  `cp .githeroku  .git/config`
  
  `git add . && git commit -m "updated .gems manifest" && git push origin master`
end
