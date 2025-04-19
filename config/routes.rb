Rails.application.routes.draw do
  
  namespace :auth do
    post "/signin", to: "Auth#sign_in"
    post "/signout", to: "Auth#sign_out"
  end
  
end
