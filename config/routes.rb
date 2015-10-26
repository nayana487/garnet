Rails.application.routes.draw do
  root to: "users#show"

  get "/errareHumanumEst", to: "errors#show", as: :error

  get '/sign_in', to: 'users#sign_in', as: :sign_in
  post '/sign_in', to: 'users#sign_in!'
  get '/sign_out', to: 'users#sign_out', as: :sign_out

  get "github/authorize", to: "users#gh_authorize", as: :gh_authorize
  get "github/authenticate", to: "users#gh_authenticate", as: :gh_authenticate
  get "github/refresh", to: "users#gh_refresh", as: :gh_refresh

  resources :groups, param: :path, except: :create do
    post "", action: :create, as: :subgroup
    get "refresh_all", action: :gh_refresh_all, as: :refresh

    resources :events, only: [:index, :create, :destroy]
    resources :attendances, only: [:index]

    resources :assignments, only: [:index, :create, :show]

    resources :observations, only: [:index]

    resources :memberships, path: "users", param: :user do
      resources :observations, only: [:create]
    end
  end

  get "orphans", to: "users#orphans", as: :orphans
  resources :users, param: :user do
    put 'refresh_memberships', on: :member
    get "is_authorized", action: :is_authorized?
  end

  resources :events, only: [:show, :create, :destroy]
  patch "attendance", to: "attendances#update", as: :attendance_update

  resources :assignments, only: [:show, :destroy] do
    resources :submissions, only: [:index, :create, :show]
  end

  resources :submissions

end
