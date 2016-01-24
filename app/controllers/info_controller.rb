class InfoController < ApplicationController
  def configuration
    @services = Service.all
    @plex_services = PlexService.all
  end

  def about
    @services = Service.all
    @plex_services = PlexService.all
  end

  def status
    @services = Service.all
    @plex_services = PlexService.all
  end
end
