require 'telegram/bot'
token = '435500633:AAFuGWgIWe93uEEFBKFZMn8p1OpCirnnMe4'
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
      when '/start'
        bot.api.sendMessage(
            chat_id: message.chat.id,
            text: "Добрый день #{message.from.email}, я бот председатель ТСЖ 'Красногорский бульвар 25'!"
        )
      when '/комуналка'
        bot.api.sendMessage(
            chat_id: message.chat.id,
            text: "Ваш долг за комунальные услуги #{rand(250000)} руб. #{rand(100)} коп."
        )
    end
  end
end

