Rails.application.routes.draw do
  resources :posts

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "posts#index"

  get 'users/:id', to: 'users#show', as: 'user'
  post 'users', to: 'devise/registrations#create', as: 'new_user'
end
