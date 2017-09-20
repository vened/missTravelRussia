class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
      # if user.admin?
      #   scope.all
      # else user.user?
      #   scope.all
      # end
    end
  end

  def index?
    @current_user.admin?
  end

  def show_member?
    @current_user.admin?
  end

  def show?
    scope.all
  end

  def edit?
    @current_user.admin? || @current_user == @user
  end

  def profile?
    @current_user == @user
  end

  def update?
    @current_user.admin? || @current_user.user? or @current_user == @user
  end

  def upload?
    @current_user == @user
  end

  def is_voted?
    @current_user.admin? || @current_user.user? or @current_user == @user
  end

  def votes?
    true
  end

  def voteable?
    @current_user.admin? || @current_user.user? or @current_user == @user
  end

  def votes_voteable?
    @current_user.admin? || @current_user.user? or @current_user == @user
  end

  def edit_photo?
    @current_user.admin? || @current_user.user? or @current_user == @user
  end

  def destroy_photo?
    @current_user.admin? || @current_user.user? or @current_user == @user
  end

  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end

end