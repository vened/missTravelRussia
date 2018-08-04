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
          :last_name_zagran,
          :name_zagran,
          :birth_date,
          :passport_number,
          :passport_expire,
          :phone,
          :email,
          :company,
          :position,
          :visa,
          :transfer_1,
          :transfer_2,
          :comments,
          :personal_confirm,
          :package,
      )
    end

end
