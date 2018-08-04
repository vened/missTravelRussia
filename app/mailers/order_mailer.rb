class OrderMailer < ApplicationMailer

  def new_order(order)
    @order = order
    @url = 'https://missturizm.ru/'
    mail(to: 'ebezhanova@onlinetours.travel',
         from: 'info@missturizm.ru',
         subject: "Новая заявка на участие в финале конкурса Мисс Туризм 2018")
  end

  def new_user_order(order)
    @order = order
    @url = 'https://missturizm.ru/'
    mail(to: @order.email,
         from: 'info@missturizm.ru',
         subject: "Ваша заявка на участие в финале конкурса Мисс Туризм 2018 принята (missturizm.ru)")
  end

end
