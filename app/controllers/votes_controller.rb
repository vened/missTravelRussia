class VotesController < ApplicationController
  def index
    @users = User.where(_role: 'user')
  end
end
