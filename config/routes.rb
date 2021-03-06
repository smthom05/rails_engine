Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      # Merchant Routes
      get 'merchants/find_all', to: "merchants/search#index"
      get 'merchants/find', to: "merchants/search#show"
      get 'merchants/:id/items', to: "merchants/items#index"
      get 'merchants/:id/invoices', to: "merchants/invoices#index"
      get "merchants/most_revenue", to: "merchants/most_revenue#index"
      resources :merchants, only: [:index, :show]

      # Customer Routes
      get 'customers/find', to: "customers/search#show"
      get 'customers/find_all', to: "customers/search#index"
      get 'customers/:id/invoices', to: "customers/invoices#index"
      get 'customers/:id/transactions', to: "customers/transactions#index"
      resources :customers, only: [:index, :show]

      # Invoice Routes
      get 'invoices/find', to: "invoices/search#show"
      get 'invoices/find_all', to: 'invoices/search#index'
      get 'invoices/:id/items', to: 'invoices/items#index'
      resources :invoices, only: [:index, :show]

      # Transaction Routes
      get 'transactions/find', to: "transactions/search#show"
      get "transactions/find_all", to: "transactions/search#index"
      get "transactions/:id/invoice", to: "transactions/invoices#show"
      resources :transactions, only: [:index, :show]

      # Items Routes
      get 'items/find', to: "items/search#show"
      get 'items/find_all', to: "items/search#index"
      get 'items/:id/invoice_items', to: "items/invoice_items#index"
      get 'items/:id/merchant', to: "items/merchants#show"
      resources :items, only: [:index, :show]

      # InvoiceItem Routes
      get 'invoice_items/find', to: "invoice_items/search#show"
      get 'invoice_items/find_all', to: 'invoice_items/search#index'
      resources :invoice_items, only: [:index, :show]
    end
  end
end
