Rails.application.routes.draw do
  devise_for :accounts
  get 'hello_world', to: 'hello_world#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'signup', to: 'accounts#signup'
  post 'signin', to: 'accounts#signin'
  get 'getinfo', to: 'accounts#getinfo'
  delete 'logout', to: 'accounts#logout'

  post 'memos', to: 'memos#create'
  get 'memos', to: 'memos#index'
  delete 'memos/:id', to: 'memos#destroy'
  patch 'memos/:id', to: 'memos#update'

  post 'auth_account', to: 'authentication#authenticate_account'
end
