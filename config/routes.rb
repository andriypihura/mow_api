Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'
  post 'protected', to: 'authentication#already_authorized'

  resources :users, only: [:create, :show, :update, :destroy] do
    resources :menus do
      resources :menu_items
    end
  end

  resources :recipes do
    resources :comments, only: [:create, :update, :destroy]
  end

  resources :likes, only: [:create, :destroy]
end
