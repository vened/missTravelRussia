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
      user.location = 'Москва'
      user.organization_site = 'site.ru'
    end
    user.admin!
    log(user)
  end

  def create_users
    arr = Array.new(20) {|index| index}
    arr.each do |index|
      user = User.find_or_create_by!(email: "user#{50+ index}@example.com") do |user|
        user.password = 'qwerty'
        user.password_confirmation = 'qwerty'
        user.name = 'Екатерина Антонова'
        user.about = 'about Екатерина Антонова'
        user.organization = 'Lavel Travel'
        user.organization_site = 'https://level.travel/'
        user.position = 'Директор'
        user.work_experience = index + 1
        user.age = 18 + index
        user.location = 'Москва'
        user.organization_site = 'site.ru'
        user.is_vote = true
      end
      photo = user.photos.create(:photo_src => File.open(Rails.root.to_s + "/public/content/1.jpg"))
      photo.update(root: true)
      user.photos.create(:photo_src => File.open(Rails.root.to_s + "/public/content/2.jpg"))
      log(user)
    end
  end


  def update_votes(user_id)
    # @users = VotesQuery.new.call()
    # @users.each do |user|
    p "==="
    p user_id
    user_voteable = User.where({user_voteables: {
        '$all' => [{'$elemMatch' => {user_voteable_id: user_id}}]
    }})
    p "----"
    @user = User.find_by(number: user_id)
    p "user.number #{user.number}"
    p "user.votes #{user.votes}"
    votes = user_voteable.length
    p "user_voteable.length #{votes}"
    @user.update(votes: votes)
    @user.save
    # end
  end


  private
  def log user
    delimiter = Array.new(160) {|index| '-'}
    puts delimiter.join
    puts 'CREATED USER: ' << user.email
    puts 'ROLE: ' << user.role.to_s
    puts delimiter.join
  end

end