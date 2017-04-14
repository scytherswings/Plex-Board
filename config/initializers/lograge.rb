Rails.application.configure do

  unless ENV['RAILS_ENV'] == 'test'
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