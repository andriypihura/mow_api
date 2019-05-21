Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      get 'checkauth', to: 'authentication#checkauth'
      post 'filter', to: 'filter#filter'

      resources :users, only: [:create, :show, :update, :destroy] do
        resources :menus do
          resources :menu_items
        end
      end

      resources :recipes do
        resources :comments, only: [:create, :update, :destroy]
        collection do
          get :overview
          post :filter
        end
      end

      resources :likes, only: [:create, :destroy]
    end
  end
end
