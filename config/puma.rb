#!/usr/bin/env puma

require 'yaml'
threads 0, 32

if ENV['DOCKER']
  puts 'Detected DOCKER environment.'
  daemonize false
  bind 'tcp://0.0.0.0:3000'
elsif Gem.win_platform?
  puts "Looks like we're running on Windows. Not Daemonizing."
  daemonize false
  puts 'Redirecting log output! If you run into any issues, check the error logs in: log/production.stderr.log, log/production.stdout.log, and log/production.log'
  stdout_redirect 'log/production.stdout.log', 'log/production.stderr.log', true

  web_host = YAML.load_file('server_config.yml')['web_host']
  port = YAML.load_file('server_config.yml')['port']

  web_host_binding = "tcp://#{web_host}:#{port}"
  puts "Binding puma to: #{web_host_binding}"
  bind web_host_binding
else
  if YAML.load_file('server_config.yml')['use_reverse_proxy']
    puts 'Binding to unix socket because use_reverse_proxy was set to "true"'
    bind "unix://#{Dir.pwd}/tmp/sockets/puma.sock"
    pidfile "#{Dir.pwd}/tmp/pids/puma.pid"
    state_path "#{Dir.pwd}/tmp/pids/puma.state"
    activate_control_app
  else
    web_host = YAML.load_file('server_config.yml')['web_host']
    port = YAML.load_file('server_config.yml')['port']

    web_host_binding = "tcp://#{web_host}:#{port}"
    puts "Binding puma to: #{web_host_binding}"
    bind web_host_binding
  end

  if ENV['NO_DAEMONIZE'] || ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
    puts 'Detected NO_DAEMONIZE. Not daemonizing.'
    daemonize false
  else
    puts 'Redirecting log output! If you run into any issues, check the error logs in: log/production.stderr.log, log/production.stdout.log, and log/production.log'
    puts 'If you need to stop the service run ./stopServer.sh'
    stdout_redirect 'log/production.stdout.log', 'log/production.stderr.log', true
    pidfile "#{Dir.pwd}/tmp/pids/puma.pid"
    state_path "#{Dir.pwd}/tmp/pids/puma.state"
    daemonize true
  end
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
