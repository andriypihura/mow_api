Rails.application.routes.draw do

  post 'authenticate', to: 'authentication#authenticate'

  resources :users, only: [:create, :show, :update, :destroy]
  resources :recipes
  resources :menu_items
  resources :menus
  resources :comments
  resources :likes
end
