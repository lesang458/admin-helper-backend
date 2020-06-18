Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post  'login', to: 'sessions#create'
      resources :users, only: %i[index create]
      get 'user', to: 'users#show'
    end
  end
end
