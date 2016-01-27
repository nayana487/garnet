Rails.application.routes.draw do
  resources :courses
  resources :locations

  root to: "dashboards#to_do"

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
    resources :memberships, only: [:create]
  end

  resources :memberships, only: [:show, :destroy] do
    post :toggle_active, on: :member
    post :toggle_admin, on: :member
  end

  resources :taggings, only: [:create, :destroy]

  resources :users, param: :user do
    member do
      get "is_registered", action: :is_registered?
      get 'gh_refresh'
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

  resources :submissions,   only: [:update, :destroy] do
    put :update_score  
  end

  resources :attendances,   only: [:update, :destroy]
  resources :observations,  only: [:create, :destroy]
end
