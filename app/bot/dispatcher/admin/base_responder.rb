# frozen_string_literal: true

# require './app/bots/responders/responder'

module Dispatcher
  class Admin::BaseResponder < Base
    def command_start
      user.start!

      send_message(chat_id: user.telegram_id, text: I18n.t(:'user.start', name: user.name))
    end
  end
end
