class PagesController < ApplicationController
  def home
    @users = VotesQuery.new.call(votes:  '-1').limit(10)
    @users_all = VotesQuery.new.call()
    @votes_count = VotesQuery.new.votes_count()
  end

  def personal_information
  end
end
