config_file = Rails.root.join('server_config.yml')

if config_file.exist?
  server_config = YAML.load_file(config_file)

  relative_root = server_config['relative_root']

  unless relative_root.blank?
    Rails.logger.info("Setting relative_root to: #{relative_root}")
    ENV['RAILS_RELATIVE_URL_ROOT'] = relative_root
  end
end