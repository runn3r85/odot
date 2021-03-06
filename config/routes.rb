Odot::Application.routes.draw do

  namespace :api do
    # namespace :v1 do

    # end
    resources :todo_lists do
      resources :todo_items, only: [:create, :update, :destroy]
    end
  end


  get "/login", to: "user_sessions#new", as: :login
  delete "/logout", to: "user_sessions#destroy", as: :logout

  resources :users, except: [:show]
  resources :user_sessions, only: [:create]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :todo_lists do
    put :email, on: :member
  	resources :todo_items do
  		member do
  			patch :complete
  		end
  	end
  end


  root 'pages#home'
end
