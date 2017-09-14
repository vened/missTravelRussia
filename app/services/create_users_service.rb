class CreateUsersService
  def call
    create_admin
    create_users
  end

  def create_admin
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
      user.password = Rails.application.secrets.admin_password
      user.password_confirmation = Rails.application.secrets.admin_password
      user.name = 'Екатерина Антонова'
      user.about = 'about Екатерина Антонова'
      user.organization = 'Lavel Travel'
      user.organization_site = 'https://level.travel/'
      user.position = 'Директор'
      user.work_experience = 99
      user.age = 18
    end
    user.admin!
    log(user)
  end

  def create_users
    arr = Array.new(20){ |index| index }
    arr.each do |index|
      user = User.find_or_create_by!(email: "user#{index}@example.com") do |user|
        user.password = 'qwerty'
        user.password_confirmation = 'qwerty'
        user.name = 'Екатерина Антонова'
        user.about = 'about Екатерина Антонова'
        user.organization = 'Lavel Travel'
        user.organization_site = 'https://level.travel/'
        user.position = 'Директор'
        user.work_experience = index + 1
        user.age = 18 + index
      end
      photo = user.photos.create(:photo_src => File.open(Rails.root.to_s + "/public/content/1.jpg"))
      photo.update(root: true)
      user.photos.create(:photo_src => File.open(Rails.root.to_s + "/public/content/2.jpg"))
      user.photos.create(:photo_src => File.open(Rails.root.to_s + "/public/content/3.jpg"))
      user.photos.create(:photo_src => File.open(Rails.root.to_s + "/public/content/4.jpg"))
      log(user)
    end
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