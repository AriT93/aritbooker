set :application, "aritbooker"
set :repository,  "git@github.com:AriT93/aritbooker.git"
set :deploy_to, "/home/aritbooker/"
set :user, "abturet"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "aritbooker.turetzky.org"                          # Your HTTP server, Apache/etc
role :app, "aritbooker.turetzky.org"                          # This may be the same as your `Web` server
role :db,  "aritbooker.turetzky.org", :primary => true # This is where Rails migrations will run
role :db,  "aritbooker.turetzky.org"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
