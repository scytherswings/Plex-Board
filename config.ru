# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
# run Rails.application
config_file = 'server_config.yml'
if !File.exist?(config_file)
  error_string = "Plex-Board was started without a #{config_file}. You should not run without it. RTFM."
  puts error_string
  Rails.logger.error error_string
else
  relative_root = YAML.load_file(config_file)['relative_root']
end
relative_root ||= '/'
map relative_root do
  run Rails.application
end