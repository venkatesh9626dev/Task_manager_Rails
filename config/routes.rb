require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  post "/signin", to: "auth#sign_in", as: :signin
  post "/signout", to: "auth#sign_out", as: :signout
  # Nested resources for employees and tasks under teams
  resources :teams , module: :teams do
    resources :team_members,  shallow: true do
      member do
        get :tasks, to: "tasks#show_team_member_tasks", as: :team_member_tasks
      end
    end

    scope module: nil do
      resources :tasks , only: [:index, :create] 
    end
  end

  resources :tasks, module: :tasks, only: [:show, :destroy, :update] do
    resources :comments, shallow:true
  end

  resources :users

end
