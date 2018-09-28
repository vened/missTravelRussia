class PagesController < ApplicationController
  def home
    params = {}
    params[:votes] = "-1"
    @users = VotesQuery.new.sort_by_votes(params).page(1).per(10)
    @users_all = VotesQuery.new.call()
    @votes_count = VotesQuery.new.votes_count()
  end

  def personal_information
  end

  def general_partner
  end

  def semifinal
    @users = SemifinalQuery.new.call()
  end

  def final
    @users = FinalQuery.new.call()
  end

end
