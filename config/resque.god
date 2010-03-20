rack_env    = ENV['RACK_ENV']  || "production"
root_dir    = ENV['ROOT_DIR']  || "/u/apps/boughtstuff/current"
num_workers = rack_env == 'production' ? 1 : 2

num_workers.times do |num|
  God.watch do |w|
    w.name     = "resque-#{num}"
    w.group    = 'resque'
    w.interval = 30.seconds
    w.env      = {"QUEUE"=>"twitter", "RACK_ENV"=>rack_env}
    w.start    = "/opt/mri-1.9.1-boughtstuff/bin/rake -f #{root_dir}/Rakefile resque:work"

    w.uid = 'ubuntu'
    w.gid = 'ubuntu'

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
