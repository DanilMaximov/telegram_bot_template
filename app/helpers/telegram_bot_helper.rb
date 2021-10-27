# frozen_string_literal: true

module TelegramBotHelper
  CALLBACK_DATA_SIZE_LIMIT = 64

  def generate_inline_buttons(buttons, message_id:, split_by: 1)
    kb = buttons.map do |button|
      ::Telegram::Bot::Types::InlineKeyboardButton.new(
        text: button[:text],
        callback_data: button_data(button, message_id)
      )
    end.each_slice(split_by)

    ::Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
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

  private

  def button_data(button, message_id)
    data = button.except(:text).to_json

    raise "callback_data size must be less than 64 bytes, current size: #{data.bytesize}, data: #{data.to_json}" if data.bytesize > CALLBACK_DATA_SIZE_LIMIT

    data
  end
end
