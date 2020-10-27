Rails.application.routes.draw do
  get '/api_docs', to: 'swagger_api#index'
  namespace :api do
    namespace :v1 do
      post  'login', to: 'sessions#create'
      post 'google_login', to: 'sessions#google_login'
      resources :employees, only: %i[index create show update] do
        member do
          patch '/status', to: 'employees#update_status'
          patch '/password', to: 'employees#update_password'
        end
      end
      post 'employees/:id/day-off-requests', to: 'day_off_request#create'
      get 'employees/:id/day-off-requests', to: 'day_off_request#index'
      resources :day_off_request, only: %i[index update destroy]
      post 'password/validate_token', to: 'password#validate_token'
      resources :password, only: %i[create]
      patch 'password/reset', to: 'password#update'
      resources :day_off_info, only: %i[update index create] do
        member do
          patch '/deactivate', to: 'day_off_info#deactivate'
        end
      end
      resources :day_off_categories, only: %i[index update create] do
        member do
          patch '/deactivate', to: 'day_off_categories#deactivate'
          patch '/activate', to: 'day_off_categories#activate'
        end
      end
      resources :device_categories, except: %i[destroy]
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
