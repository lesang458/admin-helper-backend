Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post  'login', to: 'sessions#create'
      resources :employees, only: %i[index create show]
      put 'employees/:id', :to => 'employees#update'
      patch 'employees/:id/status', :to => 'employees#update_status'
      resources :password, only: %i[create update]
      get 'password/check_token', to: 'password#valid_token?'
    end
  end
end
