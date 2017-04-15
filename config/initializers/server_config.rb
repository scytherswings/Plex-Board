config_file = Rails.root.join('server_config.yml')

if config_file.exist?
  relative_root = YAML.load_file(config_file)['relative_root']

  unless relative_root.blank?
    puts "Setting relative_root to: #{relative_root}"
    Rails.application.config.relative_url_root = relative_root
    Rails.application.config.action_controller.relative_url_root = relative_root
    ENV['RAILS_RELATIVE_URL_ROOT'] = relative_root
    ENV['ROOT_URL'] = relative_root
  end
else
  raise StandardError('The config file: server_config.yml was not found. RTFM.')
end