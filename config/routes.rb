Rails.application.routes.draw do
  
  post "/signin", to: "auth#sign_in", as: :login
  post "/signout", to: "auth#sign_out", as: :logout


  # Nested resources for employees and tasks under teams
  resources :teams , module: :teams do
    resources :team_members 
  end
  get "/teams/:team_id/tasks", to: "tasks/tasks#show_team_tasks", as: :team_tasks
  get "/teams/:team_id/team_members/:id/tasks", to: "tasks/tasks#show_team_member_tasks", as: :team_member_tasks
  resources :tasks, module: :tasks do
    resources :comments
  end

  resources :users


end
