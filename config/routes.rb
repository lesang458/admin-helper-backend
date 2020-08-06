Rails.application.routes.draw do
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
      post 'google_login', to: 'sessions#google_login'
      get 'device_histories', to: 'device_histories#index'
      post 'devices', to: 'devices#create'
      get 'devices', to: 'devices#index'
    end
  end
end
