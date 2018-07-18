class PagesController < ApplicationController
  def home
    params = {}
    params[:votes] = "1"
    @users = VotesQuery.new.call(params).page(1).per(10)
    @users_all = VotesQuery.new.call()
    @votes_count = VotesQuery.new.votes_count()
  end

  def personal_information
  end

  def general_partner
  end

end
