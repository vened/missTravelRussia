Rails.application.routes.draw do

  root 'pages#home'
  get 'personal_information' => 'pages#personal_information'


  resources :votes, only: [:index]

  resources :users, path: 'members', only: [:index, :show, :edit, :update]
  post 'members/upload/:id' => 'users#upload', as: 'members_upload'
  put 'members/:user_id/photos/:id/edit' => 'users#edit_photo', as: 'members_edit_photo'
  delete 'members/:user_id/photos/:id' => 'users#destroy_photo', as: 'members_photo'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

end
