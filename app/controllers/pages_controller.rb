class PagesController < ApplicationController
  def home
    @users = VotesQuery.new.call().limit(12)
  end

  def personal_information
  end
end
