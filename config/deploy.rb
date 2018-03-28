#require 'mina/rails'
require 'mina/deploy'
require 'mina/bundler'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :application_name, 'liked'
set :domain, '172.28.128.9'
set :deploy_to, '/var/apps/liked'
set :repository, 'https://github.com/jerryhsieh/ruby-cucumber.git'
set :branch, 'master'
set :unicorn_conf, 'config/unicorn.rb'


# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

set :user, 'liked'
set :forward_agent, true
set :identity_file, '/Users/jerryhsieh/.ssh/id_rsa'
set :rbenv_path, '/usr/local/rbenv'


# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
 # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
  invoke :'rbenv:load'
  #command "export PATH=/opt/rbenv/bin:/opt/rbenv/shims:$PATH"
  command %[ export PATH="$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/shims" ]
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup => :remote_environment  do
  # command %{rbenv install 2.3.0 --skip-existing}
  command "mkdir -p #{fetch(:deploy_to)}/current/tmp/pids #{fetch(:deploy_to)}/current/tmp/sockets"
  command "mkdir -p #{fetch(:deploy_to)}/current/log"
end

desc "Deploys the current version to the server."
task :deploy => :remote_environment do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    #invoke :'rails:db_migrate'
    #invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

desc "start web server using shotgun"
task :start => :remote_environment do
  command "cd #{fetch(:deploy_to)}/current && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E development -D "
end

task :restart => :remote_environment do
  command "if [ -f #{unicorn_pid}]; then kill -USR2 'cat #{unicorn_pid}'; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_fonc} -E #{env} -D; fi "
end


task :stop => :remote_environment do
  command "if [-f #{unicorn_pid }]; then kill -QUIT 'cat #{unicorn_pid}'; fi"
end


# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
