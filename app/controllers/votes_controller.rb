class VotesController < ApplicationController
  def index
    @users = VotesQuery.new.call().page(params[:page])
  end
end
