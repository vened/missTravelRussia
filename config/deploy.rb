require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/nginx'
require 'mina/puma'

set :user, 'deployTest1'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
set :forward_agent, true     # SSH forward_agent.

set :application_name, 'missTravelRussia'
set :domain, 'hatharoom.ru'

set :shared_dirs,  fetch(:shared_dirs, []).push('tmp', 'log', 'public/uploads', 'public/system')
set :shared_files, fetch(:shared_files, []).push('config/puma.rb', 'config/mongoid.yml', 'config/secrets.yml')
set :deploy_to, "/home/deployTest1/www/#{fetch(:application_name)}"

set :repository, 'git@github.com:vened/missTravelRussia.git'
set :branch, 'master'
set :rvm_use_path, "/home/#{fetch(:user)}/.rvm/bin/rvm"

set :rails_env, 'production'

task :environment do
  invoke :'rvm:use', 'ruby-2.4.1-p111@default'
end

task :setup do
  # command %{source #{fetch('/home/deployTest1/.nvm/nvm.sh')}}
  # command %{/home/deployTest1/.nvm/nvm.sh list}
  # command %{rbenv install 2.3.0}
  # command %{source #{fetch(:rvm_use_path)}}
  # command %{rvm install 2.3.1}

  command %{mkdir -p "#{fetch(:shared_path)}/log"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"}

  command %{mkdir -p "#{fetch(:shared_path)}/config"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"}

  command %{touch "#{fetch(:shared_path)}/config/puma.rb"}
  command %{touch "#{fetch(:shared_path)}/config/mongoid.yml"}
  command %{touch "#{fetch(:shared_path)}/config/secrets.yml"}

  command %{mkdir -p "#{fetch(:shared_path)}/tmp/sockets"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/sockets"}
  command %{mkdir -p "#{fetch(:shared_path)}/tmp/pids"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids"}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_create'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    # on :build do
      # invoke :'bundle:install'
      # invoke :'rails:db_create'
    # end

    on :launch do
      invoke :'puma:restart'
      # in_path(fetch(:current_path)) do
      #   command %{mkdir -p tmp/}
      #   command %{touch tmp/restart.txt}
      # end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
