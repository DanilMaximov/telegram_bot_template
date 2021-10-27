# frozen_string_literal: true

module Dispatcher
  class User::BaseResponder < Base
    # Text / Commands
    def command_start
      user.start!

      send_message(chat_id: user.telegram_id, text: I18n.t(:'user.start', name: user.name))
    end

    # Buttons
  end
end
