Rails.application.routes.draw do
  
  post "/signin", to: "auth#sign_in", as: :login
  post "/signout", to: "auth#sign_out"


  # Nested resources for employees and tasks under teams
  namespace :teams do
    resources :employees
    resources :tasks
  end

  resources :tasks do
    resources :comments
  end

  namespace :admin do
    resources :users
  end

  resources :teams

 

end
