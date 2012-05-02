require 'rvm/capistrano'
require 'bundler/capistrano'

set :rvm_ruby_string, "1.9.3-p125"
set :rvm_type, :user

set :application, "money_minder"
set :repository,  "git@github.com:johnnylaw/money_minder.git"
set :deploy_to, "/srv/#{application}"
set :scm, :git
set :ssh_options, { :forward_agent => true }
server '108.171.173.27', :web, :app, :db, :primary => true
set :user, 'john'
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :bundle_gemfile, "Gemfile"
set :bundle_dir,     File.join(fetch(:shared_path), 'bundle')
set :bundle_flags,   "--deployment --quiet --binstubs"
set :bundle_without, [:development, :test, :deploy, :assets]
set :bundle_cmd,     '/home/john/.rvm/gems/ruby-1.9.3-p125/bin/bundle' # e.g. "/opt/ruby/bin/bundle"
# default_run_options[:shell] = '/bin/bash'
# set :rake, '/home/john/.rvm/gems/ruby-1.9.3-p125/bin/bundle exec rake'
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# before 'deploy:setup', 'rvm:install_rvm'
after 'deploy:update_code', 'deploy:link_database_yml'
# after 'deploy:link_database_yml', 'deploy:migrate'
 
namespace :deploy do
  task :link_database_yml, :roles => :app do
    shared_db_file = File.expand_path('../shared/config/database.yml', current_path)
    symlink_location = File.expand_path('config/database.yml', current_path)
    run "ln -fs #{shared_db_file} #{symlink_location}"
  end
end
# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end