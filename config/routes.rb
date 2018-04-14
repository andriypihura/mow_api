Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'
  get 'checkauth', to: 'authentication#checkauth'

  resources :users, only: [:create, :show, :update, :destroy] do
    resources :menus do
      resources :menu_items
    end
  end

  resources :recipes do
    resources :comments, only: [:create, :update, :destroy]
    collection do
      post :filter
    end
  end

  resources :likes, only: [:create, :destroy]
end
