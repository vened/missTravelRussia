#!/usr/bin/env puma

#/home/deployTest1/www/missTravelRussia/shared/config

environment "production"

bind "unix:///home/deployTest1/www/missTravelRussia/shared/tmp/sockets/puma.sock"
pidfile "/home/deployTest1/www/missTravelRussia/shared/tmp/pids/puma.pid"
state_path "/home/deployTest1/www/missTravelRussia/shared/tmp/sockets/puma.state"
directory "/home/deployTest1/www/missTravelRussia/current"

# stdout_redirect "/home/deployTest1/www/missTravelRussiashared/log/puma_access.log",
#                 "/home/deployTest1/www/missTravelRussiashared/log/puma_error.log",
#                 true

stdout_redirect '/home/deployTest1/www/missTravelRussia/shared/log/stdout', '/home/deployTest1/www/missTravelRussia/shared/log/stderr', true
# stdout_redirect '/u/apps/lolcat/log/stdout', '/u/apps/lolcat/log/stderr', true


workers 10
threads 1,10

#daemonize true

activate_control_app "unix:///home/deployTest1/www/missTravelRussia/shared/sockets/pumactl.sock"

# preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

#prune_bundler
#preload_app!