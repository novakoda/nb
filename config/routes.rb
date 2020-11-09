Rails.application.routes.draw do
  resources :posts, :users
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "posts#index"
end
