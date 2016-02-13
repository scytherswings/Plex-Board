# config/spring.rb
require 'active_support/core_ext/module/aliasing'
require 'spring/application'

class Spring::Application
  def connect_database_with_reconfigure_database
    disconnect_database
    reconfigure_database
    connect_database_without_reconfigure_database
  end

  alias_method_chain :connect_database, :reconfigure_database

  def reconfigure_database
    if active_record_configured?
      ActiveRecord::Base.configurations =
          Rails.application.config.database_configuration
    end
  end
end