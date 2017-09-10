class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = policy_scope(User)
    authorize @users
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes!(secure_params)
      redirect_to user_path(@user), :notice => "Вы успешно заполнили анкету участника"
    else
      redirect_to edit_user(@user), :alert => "Что то пошло не так, попробуйте ещё раз заполнить анкету"
    end
  end

  def upload
    @user = User.find(params[:id])
    authorize @user
    @user.photos.create(:photo_src => params[:user][:photo_src])
    redirect_to user_path, :notice => "User upload photo."
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
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
        :phone
    )
  end

end
