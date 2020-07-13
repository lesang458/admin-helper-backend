Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post  'login', to: 'sessions#create'
      resources :employees, only: %i[index create show]
      put 'employees/:id', :to => 'employees#update'
      patch 'employees/:id/status', :to => 'employees#update_status'
      post 'employees/:id/day-off-requests', to: 'day_off_request#create'
    end
  end
end
