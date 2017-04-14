#!/usr/bin/env puma
environment 'production'
threads 0, 32
daemonize false
stdout_redirect 'log/production.stdout.log', 'log/production.stderr.log', true
bind 'tcp://0.0.0.0:3000'
pidfile "#{Dir.pwd}/tmp/pids/puma.pid"
state_path "#{Dir.pwd}/tmp/pids/puma.state"