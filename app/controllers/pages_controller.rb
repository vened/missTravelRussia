class PagesController < ApplicationController
  def home
    @user = User.find_by(email: 'maxstbn@gmail.com')
    @user1 = User.find_by(rating: 1)
    @user2 = User.find_by(rating: 2)
    @user3 = User.find_by(rating: 3)
    @user4 = User.find_by(rating: 4)
    @user5 = User.find_by(rating: 5)
    @user6 = User.find_by(rating: 6)
    @user7 = User.find_by(rating: 7)
    @user8 = User.find_by(rating: 8)
    @user9 = User.find_by(rating: 9)
    @user10 = User.find_by(rating: 10)
  end

  def personal_information
  end

end
