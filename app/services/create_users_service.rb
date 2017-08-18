class CreateUsersService
  def call
    create_admin
    create_users
  end

  def create_admin
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
      user.password = Rails.application.secrets.admin_password
      user.password_confirmation = Rails.application.secrets.admin_password
    end
    user.admin!
    log(user)
  end

  def create_users
    user = User.find_or_create_by!(email: 'user@example.com') do |user|
      user.password = 'qwerty'
      user.password_confirmation = 'qwerty'
    end
    log(user)
  end


  private
  def log user
    delimiter = Array.new(160){ |index| '-' }
    puts delimiter.join
    puts 'CREATED USER: ' << user.email
    puts 'ROLE: ' << user.role.to_s
    puts delimiter.join
  end

end