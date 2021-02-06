Rails.application.routes.draw do
  root 'application#welcome'
  resources :collabs, :people, :roles
  get '/edges', to: 'collabs#edges'
  get '/collabs/info/:yt_id', to: 'collabs#info'
  get '/people/info/:yt_id', to: 'people#info'
  get 'people/get_id/:channel_url', to: 'people#get_id'
  post '/googlesignin', to: 'users#signin'
  post '/submit', to: 'roles#submit'
end
