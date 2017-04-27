Rails.application.routes.draw do
  root to: 'hello_world#index'
  devise_for :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'api/signup', to: 'accounts#signup'
  post 'api/signin', to: 'accounts#signin'
  delete 'api/logout', to: 'accounts#logout'

  post 'api/memos', to: 'memos#create'
  get 'api/memos', to: 'memos#index'
  delete 'api/memos/:id', to: 'memos#destroy'
  patch 'api/memos/:id', to: 'memos#update'

  # post 'api/auth_account', to: 'authentication#authenticate_account'
end
