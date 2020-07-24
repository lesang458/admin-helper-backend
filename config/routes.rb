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
      get 'oauth/:provider/callback', to: 'sessions#google_login'
      get 'day-off-categories', to: 'day_off_categories#index'
    end
  end
end
