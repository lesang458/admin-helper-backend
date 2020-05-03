Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'employees',to: 'employees#render_collection'
    end
  end
end
