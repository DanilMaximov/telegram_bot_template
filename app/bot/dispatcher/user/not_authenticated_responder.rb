module Dispatcher
  class User::NotAuthenticatedResponder < Base
    def request_access
      send_message(text: I18n.t(:'user.access_requested'), chat_id: client.user_params[:id])
    end
  end
end
