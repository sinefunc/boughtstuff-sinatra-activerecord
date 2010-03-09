ActiveRecord::Base.establish_connection(
  YAML.load_file(root_path('config', 'database.yml'))[RACK_ENV]
)
ActiveRecord::Base.logger = logger
