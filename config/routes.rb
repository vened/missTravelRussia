Rails.application.routes.draw do

  root 'pages#home'
  get 'personal_information' => 'pages#personal_information'


  get 'votes' => 'users#votes', as: 'votes'
  get 'show_member/:id' => 'users#show_member', as: 'show_member'
  get 'show_member/:id/voteable' => 'users#show_member_voteable', as: 'show_member_voteable'
  get 'votes/voteable/:id' => 'users#voteable', as: 'voteable'
  post 'votes/votes_voteable/:id' => 'users#votes_voteable', as: 'votes_voteable'
  post 'votes/is_voted/:id' => 'users#is_voted', as: 'is_voted'

  resources :users, path: 'members', only: [:index, :show, :edit, :update, :destroy]
  get 'members_votes' => 'users#members_votes', as: 'members_votes'
  post 'members/upload/:id' => 'users#upload', as: 'members_upload'
  post 'members/upload_galery' => 'users#upload_galery', as: 'members_upload_galery'
  put 'members/bot/:id' => 'users#update_bot', as: 'members_bot'
  # patch 'members/bot/:id' => 'users#update_bot', as: 'members_bot'
  put 'members/:user_id/photos/:id/edit' => 'users#edit_photo', as: 'members_edit_photo'
  put 'members/:id/update_member' => 'users#update_member', as: 'update_member'
  delete 'members/:user_id/photos/:id' => 'users#destroy_photo', as: 'members_photo'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

end
