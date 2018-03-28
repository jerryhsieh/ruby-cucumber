@dir = "/var/apps/liked/current"

# preload our app for more speed
preload_app true

worker_processes 4
working_directory @dir

timeout 30

listen "#{@dir}/tmp/sockets/unicorn.sock", :backlog => 64

# set process id path
pid "#{@dir}/tmp/pids/unicorn.pid"


# set log file paths
stderr_path "#{@dir}/log/unicorn.stderr.log"
stdout_path "#{@dir}/log/unicorn.stdout.log"

