# http://nearkun.github.io/blog/2014/08/14/authentifikacia-cherez-devise-omniauth-twitter-facebook-vkontakte/
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, :event => :authentication
      if (@user.gender === 'male')
        if request.env['HTTP_REFERER'].present? && request.env['HTTP_REFERER'] != ('http://test.ru:3000/' || 'https://missturizm.ru/')
          redirect_to(request.env['HTTP_REFERER'])
        else
          redirect_to votes_path
        end
      else
        redirect_to user_path(@user)
      end
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def vkontakte
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?

      # sign_in_and_redirect @user, :event => :authentication
      sign_in @user, :event => :authentication

      if (@user.gender === 'male')
        if request.env['HTTP_REFERER'].present? && request.env['HTTP_REFERER'] != ('http://test.ru:3000/' || 'https://missturizm.ru/')
          redirect_to(request.env['HTTP_REFERER'])
        else
          redirect_to votes_path
        end
      else
        redirect_to user_path(@user)
      end

      set_flash_message(:notice, :success, :kind => "Vkontakte") if is_navigational_format?
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end

  def passthru
    super
  end
end