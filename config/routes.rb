Rails.application.routes.draw do

  root 'pages#home'
  get 'personal_information' => 'pages#personal_information'


  get 'votes' => 'users#votes', as: 'votes'
  get 'show_member/:id' => 'users#show_member', as: 'show_member'
  get 'votes/voteable/:id' => 'users#voteable', as: 'voteable'
  post 'votes/votes_voteable/:id' => 'users#votes_voteable', as: 'votes_voteable'
  post 'votes/is_voted/:id' => 'users#is_voted', as: 'is_voted'

  resources :users, path: 'members', only: [:index, :show, :edit, :update, :destroy]
  get 'members_votes' => 'users#members_votes', as: 'members_votes'
  post 'members/upload/:id' => 'users#upload', as: 'members_upload'
  put 'members/:user_id/photos/:id/edit' => 'users#edit_photo', as: 'members_edit_photo'
  delete 'members/:user_id/photos/:id' => 'users#destroy_photo', as: 'members_photo'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

end
