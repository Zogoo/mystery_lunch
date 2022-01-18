Rails.application.routes.draw do
  namespace :admin do
    get 'users/index'
  end
  root to: 'home#index'
  devise_for :users
  resources :users

  namespace :admin do
    get 'dashboard/index'
    resources :users
  end
end
