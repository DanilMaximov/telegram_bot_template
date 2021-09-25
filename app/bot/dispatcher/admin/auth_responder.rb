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
    def button_auth 
      access = case @callback_data[:text]
      when ACCEPT then true
      when DENY then false
      end 

      access_string = access ? 'accepted' : 'denied'

      user_id = @callback_data[:user_id].to_i

      client_user = ::User.find(telegram_id: user_id)

      client_user.update(access: true)

      send_message(chat_id: user_id, text: I18n.t(:"user.service.user_#{access_string}"))

      edit_message(
        chat_id: user.telegram_id,
        text: I18n.t(:"admin.user_#{access_string}", name: client.user_link(user_id, client_user.name)),
        message_id: @callback_data[:message_id]
      )

      force_message(user_id: user_id, step: 'start') if access
    end

    # Service
    def text_respond
      send(:auth)
    end

    def button_respond
      send(:button_auth)
    end
  end
end
