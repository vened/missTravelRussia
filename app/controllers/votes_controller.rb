class VotesController < ApplicationController
  def index
    @users = User.where(_role: 'user')
  end
  def anketa
    @user = User.find(params[:id])
    @root_photo = @user.photos.present? ? @user.photos.find_by(root: true) : nil
  end
end
