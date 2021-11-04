# frozen_string_literal: true

require 'dry-initializer'

class TelegramBot
  extend Dry::Initializer

  option :parse_mode, default: -> { 'HTML' }
  option :bot, optional: true
  option :message, optional: true

  include TelegramBotHelper

  def call
    user_message = case message
      when Telegram::Bot::Types::CallbackQuery
        { type: :button, content: JSON.parse(message.data).symbolize_keys }
      when Telegram::Bot::Types::Message
        { type: :text, content: { text: message.text } }
    end

    Dispatcher::SuperBase.dispatch(message: user_message, client: self)
  end

  def send_message(text:, chat_id:, options:)
    markup = generate_inline_buttons(options[:buttons], message_id: message.message_id) if options.key?(:buttons)

    bot.api.send_message(chat_id: chat_id, text: text, parse_mode: parse_mode, reply_markup: markup)
  end

  def edit_message(text:, message_id:, chat_id:, options:)
    markup = generate_inline_buttons(options[:buttons], message_id: message_id, split_by: 4) if options.key?(:buttons)

    bot.api.edit_message_text(
      chat_id: chat_id,
      text: text,
      message_id: message_id,
      reply_markup: markup,
      parse_mode: parse_mode
    )
  end

  def initial_step = 'start'

  def invocation_command = '/start'

  def user_link(id, name) = "<a href=\"tg://user?id=#{id}\">#{name}</a>"

  def user_params
    {
      id: message.from.id.to_i,
      username: message.from.username,
      name: message.from.first_name
    }
  end

  def button_message_id
    message.message.message_id
  end
end
