Rails.application.routes.draw do
  root to: 'hello_world#index'
  devise_for :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'signup', to: 'accounts#signup'
  post 'signin', to: 'accounts#signin'
  delete 'logout', to: 'accounts#logout'

  post 'memos', to: 'memos#create'
  get 'memos', to: 'memos#index'
  delete 'memos/:id', to: 'memos#destroy'
  patch 'memos/:id', to: 'memos#update'

  post 'auth_account', to: 'authentication#authenticate_account'
end
