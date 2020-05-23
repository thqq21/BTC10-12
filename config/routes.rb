Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'user/new'
  get 'static_pages/home'
  get 'static_pages/help'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  delete '/logout', to:"sessions#destroy"
  get '/login' , to: "sessions#new"
  post '/login' , to: "sessions#create"
  get "/signup", to: "user#new"
  post "/signup",to:"user#create"
  get '/help', to: 'static_pages#help' 
  get '/about', to: 'static_pages#about'

  post '/create', to:"user#create"
  # get "/user/show", to: "user#show"
  get 'users/:id', to: 'user#show'

  # get "users/signup", to: "users#new"
  post "user/new",to: "user#create"

  get "/all", to: "user#all"

  get "/about" , to: "static_pages#about"

  get "/users/:id/edit", to: "user#edit"

  patch "users/:id", to:"user#update"


  get '/users',to: "user#index"

  post '/users', to: "user#create"

  delete '/users/:id', to: "user#destroy"
  # Viec khai bao nhu nay no co tac dung , (Kien truc REST) 
  # => Cung cap cac cai duong dan cua nguoi dungs , cung nhu ho tro view Controller nao
  resources :users

  resources :account_activations, only: :edit
end
