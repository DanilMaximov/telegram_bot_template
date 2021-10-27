# frozen_string_literal: true

module Dispatcher
  module Responding
    def send_message(text:, chat_id:, options: {})
      client.send_message(
        text: text,
        chat_id: chat_id,
        options: options
      )
    end

    def edit_message(text:, chat_id:, message_id:, options: {})
      client.edit_message(
        text: text,
        message_id: message_id,
        chat_id: chat_id,
        options: options
      )
    end

    # def method_missing(method_name)
    #   send_message(
    #     chat_id: user.telegram_id,
    #     text: "undefined step #{method_name}. You'r going to be moved to start menu"
    #   )
    #   user.start!
    # end
  end
end
