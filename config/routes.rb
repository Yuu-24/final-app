Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#home'
  get 'about',to: 'pages#about'

  get 'signup', to: 'customers#new'
  get 'login', to: 'sessions#new'
  get 'bye', to: 'sessions#bye'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :items, only: [:create, :destroy] do
    member do
      get 'download'
      post 'add'
      patch 'update'
    end
  end
  resources :customers, only: [:create, :update, :show, :destroy] do
    member do
      get 'cart'
      get 'history'
      get 'inventory'
      get 'purchase'
      get 'finalize'
    end
  end

  resources :staffs, except: [:edit] do
    member do
      get 'orders'
      get 'stock'
    end
  end

  resources :orders, only: [:destroy, :update] do
    member do
      get 'fulfill'
      get 'unfulfill'
    end
  end

end
