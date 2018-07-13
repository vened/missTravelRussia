Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'pages#home'
  get 'personal_information' => 'pages#personal_information'


  get 'votes' => 'users#votes', as: 'votes'

  get 'votes/voteable/:id' => 'users#voteable', as: 'voteable'
  post 'votes/votes_voteable/:id' => 'users#votes_voteable', as: 'votes_voteable'

  resources :users, path: 'members', only: [:show, :edit, :update, :destroy]
  post 'members/upload/:id' => 'users#upload', as: 'members_upload'

  put 'members/:user_id/photos/:id/edit' => 'users#edit_photo', as: 'members_edit_photo'
  delete 'members/:user_id/photos/:id' => 'users#destroy_photo', as: 'members_photo'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

end
