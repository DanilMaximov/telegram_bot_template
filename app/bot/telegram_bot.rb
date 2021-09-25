# frozen_string_literal: true

class TelegramBot < ApplicationBot
  include TelegramBotHelper

  def call
    user = find_user || create_user

    user_message = case message
      when Telegram::Bot::Types::CallbackQuery then button_object
      when Telegram::Bot::Types::Message then text_object
    end

    Dispatcher::SuperBase.dispatch(user, message: user_message, client: self)
  end

  def find_user
    User.find(telegram_id: message.from.id.to_i)
  end

  def create_user
    user = User.create(**user_params)

    Dispatcher::Admin::AuthResponder.call(user, client: self, message: text_object, skip_validation: true)

    user
  end

  def send_message(text:, chat_id:, options:)
    markup = generate_inline_buttons(options[:buttons], message_id: message.message_id) if options.key?(:buttons)

    bot.api.send_message(chat_id: chat_id, text: text, parse_mode: parse_mode, reply_markup: markup)
  end

  def edit_message(text:, message_id:, chat_id:, options:)
    markup = generate_inline_buttons(options[:buttons], message_id: message_id, split_by: 4) if options.key?(:buttons)

    bot.api.edit_message_text(chat_id: chat_id, text: text, message_id: message_id + 1, reply_markup: markup,
      parse_mode: parse_mode)
  rescue
    nil
  end

  private

  def button_object
    { type: BUTTON, content: JSON.parse(message.data).symbolize_keys }
  end

  def text_object
    { type: TEXT, content: message.text }
  end
end
