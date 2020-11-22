Rails.application.routes.draw do
  resources :comments
  resources :posts

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'omniauth'
  }

  get '/auth/:provider/callback', to: 'devise/sessions#create'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'posts#index', as: 'home'

  post 'posts/:id/like', to: 'posts#like', as: 'like'
  delete 'posts/:id/unlike', to: 'posts#unlike', as: 'unlike'

  get 'users/:requested_id/friend_request', to: 'users#friend_request', as: 'request'
  get 'notifications', to: 'users#notifications', as: 'notification'
  get 'friendship/:friendship_id', to: 'users#befriend', as: 'friendship'

  get 'users/:id', to: 'users#show', as: 'user'
  post 'users', to: 'devise/registrations#create', as: 'new_user'
end
