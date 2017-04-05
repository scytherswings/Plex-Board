# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
# run Rails.application
relative_root = YAML.load_file('server_config.yml')['relative_root']
relative_root ||= '/'
map relative_root do
  run Rails.application
end