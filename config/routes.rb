Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "sessions#index"

  resources :sessions, only: [:create] do
    member do
      post :renew
      post :finish
    end
  end

  resources :products, path: "estoque", only: [:index, :create] do
    member do
      post :sell
      post :restock
    end
  end

  get "tv", to: "tv#index"
  get "historico", to: "historico#index"
  get "relatorios", to: "relatorios#index"
end
