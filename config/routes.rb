Odot::Application.routes.draw do

  get "/login", to: "user_sessions#new", as: :login
  delete "/logout", to: "user_sessions#destroy", as: :logout

  resources :users
  resources :user_sessions, only: [:new, :create]

  resources :todo_lists do
  	resources :todo_items do
  		member do
  			patch :complete
  		end
  	end
  end

  root 'todo_lists#index'
end
