Rails.application.routes.draw do
  resources :courses
  resources :locations

  root to: "users#show"

  get  '/sign_in',  to: 'sessions#new',     as: :sign_in
  post '/sign_in',  to: 'sessions#create'
  get  '/sign_out', to: 'sessions#destroy', as: :sign_out

  scope :github do
    get "/authorize",     to: "sessions#gh_authorize",     as: :gh_authorize
    get "/authenticate",  to: "sessions#gh_authenticate",  as: :gh_authenticate
  end

  resources :cohorts do
    get 'gh_refresh', on: :member
    resources :events,      only: [:create]
    resources :assignments, only: [:create]
    resources :memberships, only: [:create, :update, :destroy], path: "users", param: :user do
      post :toggle_active, on: :member
    end
  end


  resources :users, param: :user do
    resources :observations, only: [:create]
    member do
      get "is_registered", action: :is_registered?
      get 'gh_refresh'
      put 'refresh_memberships'
    end
    collection do
      get "orphans", to: "users#orphans"
    end
  end

  resources :assignments, only: [:show, :update, :destroy] do
    get "issues", to: "assignments#issues", as: :issues
    resources :submissions, only: [:create]
  end

  resources :events,        only: [:show, :update, :destroy] do
    resources :attendances, only: [:create]
  end

  resources :submissions,   only: [:update, :destroy]
  resources :attendances,   only: [:update, :destroy]
  resources :observations,  only: [:destroy]

end
