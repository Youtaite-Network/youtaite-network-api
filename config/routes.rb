Rails.application.routes.draw do
  root 'application#welcome'
  resources :people, :roles
  get '/collabs', to: 'collabs#index'
  get '/edges', to: 'collabs#edges'
  get '/collabs/info/:yt_id', to: 'collabs#info'
  get '/collabs/new_random', to: 'collabs#new_random'
  get '/people/info/:yt_id', to: 'people#info'
  get 'people/info_from_url/*channel_url', to: 'people#info_from_url'
  get 'people/info_from_tw_url/*tw_url', to: 'people#info_from_tw_url'
  post '/googlesignin', to: 'users#signin'
  post '/submit', to: 'roles#submit'
end
