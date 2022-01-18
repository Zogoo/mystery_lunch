Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users
  resources :users, only: %i[index show edit update]

  namespace :admin do
    get 'users/index'
    get 'dashboard/index'
    resources :users
  end
end
