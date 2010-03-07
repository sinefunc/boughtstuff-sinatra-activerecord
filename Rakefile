desc 'Default task: run all tests'
task :default => [:test]

task :test do
  exec "thor monk:test"
end

namespace :redis do
  task :start do
    envs = ENV['RACK_ENV'] || 'development,test'
    
    envs.split(',').each do |env|
      file = %(#{env}.conf)
      conf = File.join(File.dirname(__FILE__), 'config', 'redis', file)
      
      cmd  = "redis-server #{File.expand_path(conf)}"
      
      print "Starting server (#{cmd})... "

      begin
        `#{cmd}`
      rescue
        puts "Failed!"
      else
        puts "Done!"
      end
    end
  end

  task :stop do
    envs = ENV['RACK_ENV'] || 'development,test'

    envs.split(',').each do |env|
      pid  = File.join(File.dirname(__FILE__), 'db', 'redis', env, 'redis.pid')

      begin
        print "Stopping redis server... "
        `kill -TERM #{File.read(pid)}`
        puts "Done!"
      rescue
        puts "Unable to stop the redis server"
      else
        print "Deleting PID file... "
        File.delete(pid)
        puts "Done!"
      end
    end
  end
end

