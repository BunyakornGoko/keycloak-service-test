Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Authentication routes
  get "lobby", to: "sessions#lobby"
  get "auth/callback", to: "sessions#callback"
  get "logout", to: "sessions#logout"
  
  # Debug route - only available in development
  get "debug/keycloak", to: "sessions#debug_keycloak" if Rails.env.development?

  # Homepage routes
  get "homepage", to: "homepage#index"
  
  # Defines the root path route ("/")
  root "homepage#index"
end
