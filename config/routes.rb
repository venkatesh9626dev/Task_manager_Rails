Rails.application.routes.draw do
  
  namespace :users do
    post "/signin", to: "auth#sign_in"
    post "/signout", to: "auth#sign_out"
  end


  # Nested resources for employees and tasks under teams
  namespace :teams do
    resources :employees
    resources :tasks
  end

  resources :tasks do
    resources :comments
  end

  resources :teams

 

end
