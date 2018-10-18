Rails.application.routes.draw do

  root 'homes#index'

  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users

  resources :jobs, only: [:index, :new, :create, :show]


end
