class PagesController < ApplicationController
  def home
    @users = VotesQuery.new.call(votes:  '-1').limit(10)
  end

  def personal_information
  end
end
