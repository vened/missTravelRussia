Rails.application.routes.draw do
  root 'catalog#index'
  resources :users, path: 'members', only: [:index, :show, :edit, :update]
  post 'members/upload/:id' => 'users#upload', as: 'members_upload'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
