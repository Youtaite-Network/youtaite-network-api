Rails.application.routes.draw do
  root 'application#welcome'
  resources :collabs, :people, :roles
  get '/edges', to: 'collabs#edges'
  get '/collabs/info/:yt_id', to: 'collabs#info'
  get '/people/info/:yt_id', to: 'people#info'
  get 'people/info_from_url/*channel_url', to: 'people#info_from_url'
  post '/googlesignin', to: 'users#signin'
  post '/submit', to: 'roles#submit'
end
