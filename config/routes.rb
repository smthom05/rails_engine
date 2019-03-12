Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'merchants/find_all', to: "merchants/search#index"
      get 'merchants/find', to: "merchants/search#show"
      get 'merchants/:id/items', to: "merchants/items#index"
      get 'merchants/:id/invoices', to: "merchants/invoices#index"
      resources :merchants, only: [:index, :show]
    end
  end
end
