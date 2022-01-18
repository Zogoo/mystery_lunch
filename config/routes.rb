Rails.application.routes.draw do
  namespace :admin do
    get 'users/index'
  end
  root to: 'home#index'
  devise_for :users
  resources :users, only: %i[index show edit update]

  namespace :admin do
    get 'dashboard/index'
    resources :users
  end
end
