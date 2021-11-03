# frozen_string_literal: true

module Dispatcher
  class NotAuthenticatedUser < StandardError; end

  class SuperBase
    extend Dry::Initializer

    include Responding
    include Constants
    include Concerns::ResponderRouter

    option :message
    option :client

    def self.dispatch(*args, **options)
      new(*args, **options).dispatch
    end

    def dispatch
      authorize_user!
      authenticate_user!

      responder_class.call(
        @user,
        message: message,
        client: client
      )
    # TODO: Remove this hack for preventing responder_class call
    rescue NotAuthenticatedUser
      User::NotAuthenticatedResponder.call(@user, client: client, message: { method: 'request_access' })
    end

    private

    def authorize_user!
      @user = ::User.find(telegram_id: client.user_params[:id])

      return if @user

      @user = ::User.create(
        telegram_id: client.user_params[:id],
        **client.user_params.slice(:username, :name)
      )
      Dispatcher::Admin::AuthResponder.call(@user, client: client, message: { method: 'auth' })
    end

    def authenticate_user!
      return if @user.access || @user.admin?

      raise NotAuthenticatedUser
    end

    def responder_class
      message[:type] = :command if message[:content][:text].to_s.match? COMMAND_FORMAT

      klass, method = case message[:type]
      when :text then text_routing
      when :command then command_routing
      when :button then button_routing
      end

      message[:method] ||= "#{message[:type]}_#{method || klass.downcase}"

      Object.const_get "#{namespace}::#{klass || 'Base'}Responder"
    end
  end
end
