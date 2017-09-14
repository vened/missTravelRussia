class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!, only: [:edit, :update, :upload, :edit_photo, :destroy_photo, :destroy, :voteable]
  after_action :verify_authorized, only: [:edit, :update, :upload, :edit_photo, :destroy_photo, :destroy, :voteable]

  def index
    @users = policy_scope(User)
  end

  def show
    @user = User.find_by(number: params[:id])
    @root_photo = @user.photos.present? ? @user.photos.find_by(root: true) : nil

    @user_prev = User.where(number: @user.number - 1, _role: 'user').first
    @user_next = User.where(number: @user.number + 1, _role: 'user').first

    @user_position = User.where(votes: { '$gt': @user.votes }).length + 1
  end

  def edit
    @user = User.find_by(number: params[:id])
    authorize @user
  end

  def update
    @user = User.find_by(number: params[:id])
    authorize @user
    if @user.update_attributes!(secure_params)
      redirect_to user_path(@user), :notice => "Вы успешно заполнили анкету участника"
    else
      redirect_to edit_user(@user), :alert => "Что то пошло не так, попробуйте ещё раз заполнить анкету"
    end
  end

  def upload
    @user = User.find_by(number: params[:id])
    authorize @user
    if @user.photos.length < 4
      @photo = @user.photos.create(:photo_src => params[:user][:photo_src])
      notice = "Фотография успешно загружена"
    else
      notice = "можно загрузить только 4 фотографии"
    end
    if @photo
      if @user.photos.length === 1
        @photo.update(root: true)
      else
        @photo.update(root: false)
      end
    end
    redirect_to user_path, :notice => notice
  end

  def edit_photo
    @user = User.find_by(number: params[:user_id])
    authorize @user
    @photo = @user.photos.find(params[:id])
    @user.photos.each do |photo|
      photo.update(root: false)
    end
    @photo.update(root: true)
    redirect_to user_path(@user), :notice => "Фотография успешно поставлена как главная"
  end

  def destroy_photo
    @user = User.find_by(number: params[:user_id])
    authorize @user
    @photo = @user.photos.find(params[:id])
    @photo.destroy
    if @user.photos.present? && @photo.root
      @user.photos.first.update(root: true)
    end
    redirect_to user_path(@user), :notice => "Фотография успешно удалена"
  end

  def destroy
    user = User.find_by(number: params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def voteable
    authorize current_user
    @user = VoteableService.new.call(current_user, params[:id])
    # render json: @user
    # redirect_to user_path(@user), :notice => notice
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
      format.json {render json: @user, location: @user}
    end
  end

  private

  def secure_params
    params.require(:user).permit(
        :role,
        :name,
        :organization,
        :organization_site,
        :position,
        :work_experience,
        :age,
        :photo_src,
        :phone,
        :is_vote
    )
  end

end
