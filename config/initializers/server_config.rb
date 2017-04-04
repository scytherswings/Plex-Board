config_file = Rails.root.join('server_config.yml')

if config_file.exist?
  server_config = YAML.load_file(config_file)

  relative_root = server_config['relative_root']
  web_host = server_config['web_host']
  asset_host = server_config['asset_host']

  if web_host.blank?
    Rails.logger.warn("Found a config file: #{config_file} but the web_host was blank. The value will be left at rails defaults.")
  else
    Rails.logger.info("Setting web_host to: #{web_host}")
    Rails.application.routes.default_url_options[:host] = web_host
  end

  if asset_host.blank?
    Rails.logger.warn("Found a config file: #{config_file} but the asset_host was blank. The value will be left at rails defaults.")
  else
    Rails.logger.info("Setting asset_host to: #{asset_host}")
    Rails.application.config.action_controller.asset_host = asset_host
  end

  unless relative_root.blank?
    Rails.logger.info("Setting relative_root to: #{relative_root}")
    Rails.application.config.action_controller.relative_url_root = relative_root
    Rails.application.config.relative_url_root = relative_root
  end
end