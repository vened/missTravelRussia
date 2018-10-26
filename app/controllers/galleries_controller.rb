class GalleriesController < ApplicationController
  def index
    @galleries = Gallery.order_by(created_at: -1).page(params[:page])
  end

  def show
    @gallery = Gallery.find(params[:id])
  end
end
