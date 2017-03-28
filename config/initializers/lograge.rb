ActiveRecord::Base.logger.level = Logger::INFO
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
        params: event.payload[:params].except(*exceptions)
    }
  end
  # config.lograge.ignore_actions = ['HealthCheck::HealthCheckController#index']
end