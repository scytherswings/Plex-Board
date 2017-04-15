# require 'browserlog'
Rails.application.routes.draw do

  root 'services#index'
  get 'all_services' => 'services#all_services'
  get 'choose_service_type' => 'services#choose_service_type'
  get 'about' => 'info#about'
  get 'configuration' => 'info#configuration'
  get 'plex_services/all_plex_services'
  get 'notifications' => 'notifications#notifications'
  get 'recently_added' => 'plex_services#recently_added'

  resources :services do
    get :online_status
  end

  resources :plex_services do
    get :now_playing
  end
  resources :weather


  # mount Browserlog::Engine => '/logs'

end
