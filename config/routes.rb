Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users
  resources :recipes
  resources :menu_items
  resources :menus
  resources :comments
  resources :likes
end
