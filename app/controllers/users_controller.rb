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
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def upload
    @user = User.find(params[:id])
    authorize @user
    p "-----"
    p params[:user][:photo_src]
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
    params.require(:user).permit(:role, :first_name, :sur_name, :phone, :telegram, :photo_src)
  end

end
