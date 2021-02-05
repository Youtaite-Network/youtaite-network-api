Rails.application.routes.draw do
  root 'application#welcome'
  resources :collabs, :people, :roles
  get '/edges', to: 'collabs#edges'
  get '/collabs/info/:yt_id', to: 'collabs#info'
  post '/googlesignin', to: 'users#signin'
  post '/submit', to: 'roles#submit'
end
