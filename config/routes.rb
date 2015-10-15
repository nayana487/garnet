Rails.application.routes.draw do
  root to: "users#show"

  get "/users/is_authorized", to: "users#is_authorized?"

  get '/sign_in', to: 'users#sign_in', as: :sign_in
  post '/sign_in', to: 'users#sign_in!'
  get '/sign_out', to: 'users#sign_out', as: :sign_out

  # students submissions end-point
  # get 'api/memberships/:id/submissions', to: "submissions_api#index"

  # groups api routes
  # get 'api/groups', to: "groups_api#index"
  # get 'api/groups/:id', to: "groups_api#students"
  # get 'api/groups/:id/attendance_summary', to: "groups_api#students_attendances"
  # get 'api/groups/:id/submission_summary', to: "groups_api#students_submissions"

  get "github/authorize", to: "users#gh_authorize", as: :gh_authorize
  get "github/authenticate", to: "users#gh_authenticate", as: :gh_authenticate
  get "github/refresh", to: "users#gh_refresh", as: :gh_refresh

  get "/groups/su_create", to: "groups#su_new", as: :groups_su_new
  post "/groups/su_create", to: "groups#su_create"

  get "users/refresh_all", to: "users#gh_refresh_all", as: :user_refresh_all
  resources :groups, param: :path, except: :create do
    post "", action: :create, as: :subgroup
    get "refresh_all", action: :gh_refresh_all, as: :refresh
    
    resources :events, only: [:index, :create]
    resources :attendances, only: [:index]

    resources :assignments, only: [:index, :create]
    resources :submissions, only: [:index]

    resources :observations, only: [:index]

    resources :memberships, path: "users", param: :user do
      resources :observations, only: [:index, :create]
      resources :submissions, only: [:index, :show]
      resources :attendances, only: [:index, :show]
    end
  end

  resources :users, param: :user

  resources :events do
    patch "/attendances", to: "attendances#update_all", as: :update_all
  end

  resources :assignments do
    resources :submissions
  end

end
