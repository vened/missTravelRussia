class PostsController < ApplicationController
  def index
    @posts = Post.order_by(created_at: -1).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end
end
