Rails.application.routes.draw do
  root 'application#welcome'
  resources :collabs, :people, :roles
end
