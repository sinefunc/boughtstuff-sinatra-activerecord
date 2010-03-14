task :environment do
  require 'init'
end

Dir['lib/tasks/*.rake'].each { |f| load f }

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
  
  puts  "\n-----> Starting extraction of config/rvm.gems"

  rvm_gems = File.read("config/rvm.gems").split("\n")
  
  puts  "       Read #{rvm_gems.size - 1} gem entries..."

  print "-----> Sorting through the different gems... "
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
  puts  "Done!"
  print "-----> Writing the .gems file now... "
  
  File.open('.gems', 'w') do |f|
    gems.each do |name, version|
      f.write "#{name} --version #{version}\n"
    end
    f.write "pg"
  end

  puts  "Done!"
  puts  "       Wrote #{gems.size + 1} gems to the manifest!"
end

desc "Deploy to heroku"
task :deploy => [ :create_heroku_gems_manifest, "asset:packager:build_all" ] do
  `git add . && git commit -m "updated .gems manifest on #{Time.now.utc}" && git push heroku-staging master`

  `heroku rake asset:upload:s3`
end
