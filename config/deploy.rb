# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.7.1'

set :application, 'pandore'
set :repo_url, 'git@github.com:helloshane/pandore.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :user, 'root'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/root/pandore"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", "config/application.yml", "config/unicorn.rb"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :rvm_ruby_version, '2.3.0@pandore'

set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }

set :unicorn_pid, -> { "#{current_path}/tmp/pids/unicorn.pid" }

# set :bundle_binstubs, false

set :bundle_without, %w{development test}.join(' ')

namespace :deploy do
  desc 'Restart Application'
  task :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
  after :publishing, "deploy:cleanup"
end
