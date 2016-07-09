class InfoController < ApplicationController
  def configuration
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end

  def new_weather
    @services = Service.all
    @service = Service.new
    @weather = Weather.new
    @weathers = Weather.all
    @request_value = request.location
  end

  def about
    @services = Service.all
    @plex_services = PlexService.all
    @weathers = Weather.all
  end
end
