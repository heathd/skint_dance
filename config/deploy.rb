require "bundler/capistrano"

set :rvm_ruby_string, 'ruby-1.9.3-p194'
set :rvm_type, :system
require "rvm/capistrano"

set :application, "skint_dance"
set :repository,  "git://github.com/heathd/skint_dance.git"
set :deploy_to, "/home/heathd/sites/skint_dance"
ssh_options[:keys] = %w(/Users/heathd/.ssh/id_rsa)
ssh_options[:forward_agent] = true
set :branch, "master"
set :user, "heathd"
set :deploy_via, :remote_cache

set :scm, :git

role :web, "davidheath.org"                          # Your HTTP server, Apache/etc
role :app, "davidheath.org"                          # This may be the same as your `Web` server
role :db,  "davidheath.org", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end