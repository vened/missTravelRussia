class OrdersController < ApplicationController
  def index
    @order = Order.new
  end

  def create
    @order = Order.new(secure_params)
    if @order.save
      redirect_to orders_path, :notice => "Вы успешно отправили заявку"
    else
      redirect_to orders_path, :alert => "Что то пошло не так, попробуйте ещё раз отправить заявку"
    end
  end

  private

    def secure_params
      params.require(:order).permit(
          :last_name,
          :name,
      )
    end

end
