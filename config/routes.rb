Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post   "login",       to: "sessions#create"
        post   "refresh",     to: "sessions#refresh"
        delete "logout",      to: "sessions#destroy"
        post   "impersonate", to: "impersonate#create"
      end

      resources :organizations, only: [ :index ]
    end
  end
end
