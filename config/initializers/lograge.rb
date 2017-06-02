Rails.application.configure do

  unless Rails.env == 'test'
    ActiveRecord::Base.logger.level = Logger::INFO
  end

  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
        params: event.payload[:params].except(*exceptions)
    }
  end
end