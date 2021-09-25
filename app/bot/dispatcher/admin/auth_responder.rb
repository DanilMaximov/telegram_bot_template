# frozen_string_literal: true

module Dispatcher
  class Admin::AuthResponder < Base
    AUTH_BUTTONS = [
      ACCEPT = 'Accept',
      DENY = 'Deny'
    ].freeze

    def auth
      text = I18n.t(:'admin.new_user', name: client.user_link(client.user_params[:telegram_id], client.user_params[:name]))

      admin_id = ::User.find(role: ::ApplicationBot::ADMIN)&.telegram_id || ENV['ADMIN_ID']

      send_message(
        text: text,
        chat_id: admin_id,
        options: {
          buttons: [
            { text: ACCEPT, user_id: client.user_params[:telegram_id] },
            { text: DENY, user_id: client.user_params[:telegram_id] }
          ]
        }
      )

      send_message(text: I18n.t(:'user.access_requested'), chat_id: client.user_params[:telegram_id])
    end

    # Buttons
    def button_accept
      user_id = @callback_data[:user_id].to_i

      client_user = ::User.find(telegram_id: user_id)

      client_user.update(access: true)

      send_message(chat_id: user_id, text: ::I18n.t(:'user.service.user_accepted'))

      edit_message(
        chat_id: user.telegram_id,
        text: I18n.t(:'admin.user_accepted', name: client.user_link(user_id, client_user.name)),
        message_id: @callback_data[:message_id]
      )

      force_message(user_id: user_id, step: 'start')
    end

    def button_deny
      user_id = @callback_data[:user_id].to_i

      client_user = ::User.find(id: user_id)

      client_user.update(access: true)

      send_message(chat_id: user_id, text: I18n.t(:'user.service.user_denied'))

      edit_message(
        chat_id: user.telegram_id,
        text: I18n.t(:'admin.user_denied', name: client.user_link(user_id, client_user.name)),
        message_id: @callback_data[:message_id]
      )
    end

    def text_respond
      send(:auth)
    end
  end
end
