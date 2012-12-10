set :rvm_ruby_string, 'default'
set :rvm_type, :system
require "rvm/capistrano"
require 'bundler/capistrano'

server "meejian.com", :web, :app, :db, primary: true

set :scm, :git
set :application, "meejian"
set :repository,  "git@github.com:lilu/Meejian.git"
set :user, "deployer"

set :deploy_via, :remote_cache
set :deploy_to, "/var/meejian"
set :use_sudo, false

set :ssh_options, {forward_agent: true}
set :default_run_options, {pty: true}

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /opt/nginx/conf/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  end
  after "deploy:setup", "deploy:setup_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

require './config/boot'
require 'airbrake/capistrano'
