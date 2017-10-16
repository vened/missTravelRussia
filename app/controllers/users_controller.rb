class UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!, only: [:index, :members_votes, :show_member, :edit, :update, :upload, :edit_photo, :destroy_photo, :destroy, :voteable, :is_voted]
  after_action :verify_authorized, only: [:edit, :show_member, :update, :upload, :edit_photo, :destroy_photo, :destroy, :votes, :voteable, :is_voted]

  def index
    @users = policy_scope(User)
    if params[:q].present?
      @users = @users.where(name: params[:q])
    end
    if params[:user_id].present?
      @users = @users.where(number: params[:user_id].to_f)

      # user_is = @users.where(_role: 'user', is_vote: true)
      #
      # user_is.each do |current_user|
      #   user_voteable = @users.where({user_voteables: {
      #       '$all' => [{'$elemMatch' => {user_voteable_id: "#{current_user.number}"}}]
      #   }})
      #   current_user.update_attribute(:votes, user_voteable.length)
      # end
    end
    @users = @users.page(params[:page])
    authorize User
  end

  def members_votes
    users = VotesQuery.new.call(params)
    authorize User
    respond_to do |format|
      format.html
      format.csv { send_data users.to_csv }
      format.xls
    end
  end

  def show_member
    @users = policy_scope(User)
    @user = @users.find_by(number: params[:id])

    @user_voteable = @users.where({user_voteables: {
        '$all' => [{'$elemMatch' => {user_voteable_id: params[:id]}}]
    }})

    @root_photo = @user.photos.present? ? @user.photos.find_by(root: true) : nil
    authorize User
  end

  def show
    @user = User.find_by(number: params[:id])

    @root_photo = @user.photos.present? ? @user.photos.find_by(root: true) : nil

    @user_prev = VotesQuery.new.prev_anketa(@user, params)
    @user_next = VotesQuery.new.next_anketa(@user, params)
    @user_position = VotesQuery.new.anketa_position(@user)
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

  def votes
    @users = VotesQuery.new.call(params).page(params[:page])
    authorize User
  end

  def is_voted
    @user = User.find_by(number: params[:id])
    authorize User
    @user.update_attribute('is_vote', true)
    redirect_to edit_user_path(@user), :notice => "Вы участвуете в конкурсе, заполните анкету"
  end

  def votes_voteable
    authorize current_user
    @user = VoteableService.new.call(current_user, params[:id])
    @users = VotesQuery.new.call(params).page(params[:page])
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
      format.json {render json: @user, location: @user}
    end
  end

  def voteable
    authorize current_user
    @user = VoteableService.new.call(current_user, params[:id])
    @user_position = VotesQuery.new.anketa_position(@user)
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
        :location,
        :about,
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
