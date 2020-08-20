Rails.application.routes.draw do
  get '/api_docs', to: 'swagger_api#index'
  namespace :api do
    namespace :v1 do
      post  'login', to: 'sessions#create'
      resources :employees, only: %i[index create show]
      put 'employees/:id', :to => 'employees#update'
      patch 'employees/:id/status', :to => 'employees#update_status'
      post 'employees/:id/day-off-requests', to: 'day_off_request#create'
      get 'employees/:id/day-off-requests', to: 'day_off_request#index'
      post 'password/validate_token', to: 'password#validate_token'
      resources :password, only: %i[create update]
      put 'day-off-infos/:id', to: 'day_off_info#update'
      get 'day-off-categories', to: 'day_off_categories#index'
      resources :device_categories
      post 'google_login', to: 'sessions#google_login'
      resources :device_histories, only: %i[index show]
      resources :devices, only: %i[create show index destroy update] do
        member do
          put '/discard', to: 'devices#discard'
          put 'move_to_inventory', to: 'devices#move_to_inventory'
          put '/assign', to: 'devices#assign'
        end
      end
    end
  end
end
