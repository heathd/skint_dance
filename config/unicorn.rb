root = File.dirname(File.dirname(File.dirname(__FILE__)))
working_directory "#{root}/current"
listen '127.0.0.1:9000'
listen "#{root}/shared/unicorn.socket"
worker_processes 2
pid "#{root}/shared/pids/unicorn.pid"
stderr_path "#{root}/shared/log/unicorn.log"
stdout_path "#{root}/shared/log/unicorn.log"
