Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post  'login', to: 'sessions#create'
      get 'employees', to: 'employees#index'
    end
  end
end
