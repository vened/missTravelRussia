#!/usr/bin/env puma

app_dir = "/home/deployTest1/www/missTravelRussia"
shared_dir = "#{app_dir}/shared"

environment "production"

bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/sockets/puma.state"
directory "#{app_dir}/current"

stdout_redirect "#{shared_dir}/log/puma_access.log",
                "#{shared_dir}/log/puma_error.log",
                true

workers 10
threads 1,10

daemonize true

activate_control_app "unix://#{shared_dir}/tmp/sockets/pumactl.sock"

#preload_app!

# on_worker_boot do
#   ActiveSupport.on_load(:active_record) do
#     ActiveRecord::Base.establish_connection
#   end
# end