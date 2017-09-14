class PagesController < ApplicationController
  def home
    @users = VotesQuery.new.call().limit(10)
  end

  def personal_information
  end
end
