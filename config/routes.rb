Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users
  resources :users, only: %i[index show edit update]

  namespace :admin do
    require 'sidekiq/web'
    # Allo only admin users to access to jobs
    authenticate :user, lambda { |u| u.admin? } do
      Sidekiq::Web.set :sessions, false
      mount Sidekiq::Web => '/sidekiq'
    end
    get 'users/index'
    get 'dashboard/index'
    resources :users
  end
end
