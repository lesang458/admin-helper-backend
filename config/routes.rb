Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'employees', to: 'employees#index'
    end
  end
end
