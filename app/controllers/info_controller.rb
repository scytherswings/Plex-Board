class InfoController < ApplicationController
  def configuration
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end

  def about
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end
end
