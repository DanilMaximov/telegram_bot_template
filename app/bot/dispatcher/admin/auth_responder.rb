# frozen_string_literal: true

module Dispatcher
  class Admin::AuthResponder < Base
    AUTH_BUTTONS = [
      ACCEPT = 'Accept',
      DENY = 'Deny'
    ].freeze

    def auth
      text = I18n.t(:'admin.new_user', name: client.user_link(client.user_params[:telegram_id], client.user_params[:name]))

      admin_id = ::User.find(role: ::User.admin)&.telegram_id || ENV['ADMIN_ID']

      send_message(
        text: text,
        chat_id: admin_id,
        options: {
          buttons: AUTH_BUTTONS.each_with_index.map do |text, i|            
            { text: text, tid: i, uid: client.user_params[:telegram_id], step: :auth }
          end
        }
      )

      send_message(text: I18n.t(:'user.access_requested'), chat_id: client.user_params[:telegram_id])
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
        message_id: client.message.message.message_id - 1
      )

      send_message(chat_id: user_id, text: I18n.t(:'user.start', name: user.name)) if access_given?
    end

    private

    def access_given?
      case AUTH_BUTTONS[message[:content][:tid]]
      when ACCEPT then true
      when DENY then false
      end 
    end
  end
end
