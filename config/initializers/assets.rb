# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
config_file = Rails.root.join('server_config.yml')
# asset_host = Socket.gethostbyname(Socket.gethostname).first

if config_file.exist?
  server_config = YAML.load_file(config_file)

  asset_host = server_config['asset_host']

  if asset_host.blank?
    Rails.logger.warn("Found a config file: #{config_file} but the asset_host was blank.")
  end
end

Rails.logger.info("Setting asset_host to: #{asset_host}")
Rails.application.config.action_controller.asset_host = asset_host