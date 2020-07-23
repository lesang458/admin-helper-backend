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
    end
  end
end
