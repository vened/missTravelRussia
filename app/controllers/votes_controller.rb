class VotesController < ApplicationController
  def index
    @users = VotesQuery.new.call().page(params[:page])
  end

  def anketa
    @user = User.find_by(number: params[:id])
    @root_photo = @user.photos.present? ? @user.photos.find_by(root: true) : nil
  end
end
