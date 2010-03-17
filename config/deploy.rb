# -- APP -- 
set :application, "boughtstuff"

# -- GIT -- 
set :repository,  "git@github.com:sinefunc/boughtstuff.git"
set :scm, :git
set :branch, 'production'
set :deploy_via, :remote_cache

# -- RAILS -- 
set :rack_env, 'production'
set :use_sudo, false
set :ruby_bin, '/opt/mri-1.9.1-boughtstuff/bin'

# -- SSH -- 
set :user, 'ubuntu'
set :port, 22
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "sinefunc.pem")] 

# -- ROLES --
role :web, "boughtstuff.com"
role :app, "boughtstuff.com"
role :db,  "boughtstuff.com", :primary => true 

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Create asset packages for production" 
  task :build_assets, :roles => :app do
    run <<-EOF
      cd #{release_path} && #{ruby_bin}/rake asset:packager:build_all
    EOF
  end

  desc "Upload to S3"
  task :upload_assets_to_s3, :roles => :app do
    run <<-EOF
      cd #{release_path} && #{ruby_bin}/rake asset:upload:s3
    EOF
  end

  task :symlink_database_yml, :roles => :app do
    run <<-EOF
      ln -vfs #{shared_path}/database.yml #{release_path}/config/database.yml
    EOF
  end
end

before "deploy:finalize_update", "deploy:symlink_database_yml"
before "deploy:finalize_update", "deploy:build_assets"
after  "deploy:finalize_update", "deploy:upload_assets_to_s3"
