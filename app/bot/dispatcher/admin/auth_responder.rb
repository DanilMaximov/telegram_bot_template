# frozen_string_literal: true

module Dispatcher
  class Admin::AuthResponder < Base
    def auth
      text = I18n.t(:'admin.new_user', name: client.user_link(user.telegram_id, user.name))
      admin_id = ::User.find(role: ::User.admin)&.telegram_id || ENV['ADMIN_ID']

      send_message(
        text: text,
        chat_id: admin_id,
        options: {
          buttons: [ACCEPT, DENY].map do |text|
            { text: text, tid: BUTTONS.index(text), uid: user.telegram_id }
          end
        }
      )
    end

    # Buttons
    def button_auth
      access_string = access_given? ? 'accepted' : 'denied'

      user_id = message[:content][:uid].to_i
      client_user = ::User.find(telegram_id: user_id)
      client_user.update(access: true)

      send_message(chat_id: user_id, text: I18n.t(:"user.service.user_#{access_string}"))

      edit_message(
        chat_id: user.telegram_id,
        text: I18n.t(:"admin.user_#{access_string}", name: client.user_link(user_id, client_user.name)),
        message_id: client.button_message_id
      )

      send_message(chat_id: user_id, text: I18n.t(:'user.start', name: user.name)) if access_given?
    end

    private

    def access_given?
      case BUTTONS[message[:content][:tid]]
      when ACCEPT then true
      when DENY then false
      end
    end
  end
end
