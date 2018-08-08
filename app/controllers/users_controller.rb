class UsersController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:edit, :update, :upload, :edit_photo, :destroy_photo, :destroy, :voteable]
  after_action :verify_authorized, only: [:edit, :update, :upload, :edit_photo, :destroy_photo, :destroy, :votes, :voteable]

  before_action :save_my_previous_url

  def show
    @user          = User.find_by(number: params[:id])
    @root_photo    = @user.photos.where(root: true).present? ? @user.photos.find_by(root: true) : nil
    @user_prev     = VotesQuery.new.prev_anketa(@user, params)
    @user_next     = VotesQuery.new.next_anketa(@user, params)
    @user_position = VotesQuery.new.anketa_position(@user)
    @back_url = session[:my_previous_url]
    if @user.user?
      redirect_to votes_path
    end
  end

  def edit
    @user = User.find_by(number: params[:id])
    authorize @user
  end

  def update
    @user = User.find_by(number: params[:id])
    authorize @user
    if @user.update_attributes!(secure_params)
      redirect_to user_path(@user), :notice => "Вы успешно отредактировали свою анкету"
    else
      redirect_to edit_user(@user), :alert => "Что то пошло не так, попробуйте ещё раз отредактировать анкету"
    end
  end

  def upload
    @user = User.find_by(number: params[:id])
    authorize @user
    if @user.photos.length < 4
      @photo = @user.photos.create(:photo_src => params[:photo_src])
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

    @root_photo    = @user.photos.where(root: true).present? ? @user.photos.find_by(root: true) : nil
    # redirect_to user_path, :notice => notice
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      format.json { render json: @user, location: @user }
    end
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
    @root_photo    = @user.photos.where(root: true).present? ? @user.photos.find_by(root: true) : nil
    # redirect_to user_path(@user), :notice => "Фотография успешно удалена"
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      format.json { render json: @user, location: @user }
    end
  end

  def destroy
    user = User.find_by(number: params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def votes
    @users = VotesQuery.new.call(params).page(params[:page])
    authorize User
  end

  def is_voted
    @user = User.find_by(number: params[:id])
    authorize @user
    @user.update_attribute('role', :contestant)
    redirect_to edit_user_path(@user), :notice => "Вы участвуете в конкурсе, заполните анкету"
  end

  def votes_voteable
    authorize current_user
    @user  = VoteableService.new.call(current_user, params[:id])
    @users = VotesQuery.new.call(params).page(params[:page])
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      format.json { render json: @user, location: @user }
    end
  end

  def voteable
    authorize current_user
    @user          = VoteableService.new.call(current_user, params[:id])
    @user_position = VotesQuery.new.anketa_position(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      format.json { render json: @user, location: @user }
    end
  end

  private

    def save_my_previous_url
      # session[:previous_url] is a Rails built-in variable to save last url.
      session[:my_previous_url] = URI(request.referer || '').path
    end

    def secure_params
      params.require(:user).permit(
          :role,
          :name,
          :location,
          :about,
          :organization,
          :organization_site,
          :position,
          :work_experience,
          :age,
          :photo_src,
          :phone,
          :is_vote,
          :is_bot,
          :is_disqualify,
          :votes,
          :rating,
          :email2,
      )
    end

end
