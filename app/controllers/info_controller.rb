class InfoController < ApplicationController
  before_action :set_sidebar_values

  def set_sidebar_values
    @services = Service.all
    @plex_services = PlexService.all
    # @weathers = Weather.all
  end

  def configuration
  end

  def about
  end
end
