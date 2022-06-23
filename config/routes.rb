Rails.application.routes.draw do
  root "application#welcome"
  resources :people, :roles
  get "/collabs", to: "collabs#index"
  get "/edges", to: "collabs#edges"
  get "/collabs/info/:yt_id", to: "collabs#info"
  get "/collabs/new_random", to: "collabs#new_random"
  delete "/collabs", to: "collabs#destroy"
  get "/people/info/:yt_id", to: "people#info"
  get "people/info_from_url/*url", to: "people#info_from_url", format: false
  post "/googlesignin", to: "users#signin"
  post "/submit", to: "roles#submit"
end
