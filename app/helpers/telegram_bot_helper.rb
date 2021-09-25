# frozen_string_literal: true

module TelegramBotHelper
  def generate_inline_buttons(buttons, message_id:, split_by: 1)
    kb = buttons.map do |button|
      ::Telegram::Bot::Types::InlineKeyboardButton.new(
        text: button[:text],
        callback_data: button_serializer(button, message_id)
      )
    end.each_slice(split_by)

    ::Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def button_serializer(button, message_id)
    {
      message_id: message_id,
      text: button[:text],
      **button.except(:text)
    }.to_json
  end

  def user_params
    {
      telegram_id: message.from.id.to_i,
      username: message.from.username,
      name: message.from.first_name
    }
  end

  def user_link(id, name)
    "<a href=\"tg://user?id=#{id}\">#{name}</a>"
  end
end
