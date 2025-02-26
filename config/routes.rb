Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  get "turismo", to: "tourism#index", as: :tourism_index
  get "turismo/categoria/:category", to: "tourism#index", as: :tourism_category

  # Rutas amigables para lugares destacados (deben ir antes de la ruta genérica)
  get "turismo/convento-franciscano", to: "tourism#show", defaults: { id: "ex_convento" }, as: :tourism_ex_convento
  get "turismo/museo-tepeapulco", to: "tourism#show", defaults: { id: "museo_tepeapulco" }, as: :tourism_museo
  get "turismo/presa-el-tepozan", to: "tourism#show", defaults: { id: "presa_tepozan" }, as: :tourism_presa
  get "turismo/centro-historico", to: "tourism#show", defaults: { id: "centro_historico" }, as: :tourism_centro
  get "turismo/parque-ecoturistico", to: "tourism#show", defaults: { id: "parque_ecoturistico" }, as: :tourism_parque

  # Ruta genérica para todos los lugares turísticos (debe ir después de las rutas específicas)
  get "turismo/:id", to: "tourism#show", as: :tourism_show
end
