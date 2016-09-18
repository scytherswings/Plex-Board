Rails.application.routes.draw do

  root 'services#index'
  get 'all_services' => 'services#all_services'
  get 'choose_service_type' => 'services#choose_service_type'
  get 'about' => 'info#about'
  get 'configuration' => 'info#configuration'
  get 'status' => 'info#status'
  get 'new_weather' => 'info#new_weather'
  # get 'notifications' => 'services#notifications'
  get 'plex_services/all_plex_services'

  get 'now_playing' => 'plex_services#now_playing'
  get 'recently_added' => 'plex_services#recently_added'

  resources :services do
    collection { get :notifications}
    get :online_status
  end
  # resources :now_playing, path: 'services/:id/online_status'
  resources :plex_services
  resources :weathers
end
