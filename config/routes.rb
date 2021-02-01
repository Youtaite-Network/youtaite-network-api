Rails.application.routes.draw do
  root 'application#welcome'
  resources :collabs, :people, :roles
  get '/edges', to: 'collabs#edges'
end
