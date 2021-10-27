# frozen_string_literal: true

module Dispatcher
  class NotAuthenticatedUser < StandardError; end

  class SuperBase
    extend Dry::Initializer

    include Responding
    include Constants
    param :user, Types::Instance(::User)

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
      @user = ::User.find(telegram_id: client.message.from.id.to_i)

      return if @user

      @user = ::User.create(**client.user_params)
      Dispatcher::Admin::AuthResponder.call(@user, client: client, message: { method: 'auth' })
    end

    def authenticate_user!
      return if @user.access || @user.admin?

      raise NotAuthenticatedUser
    end

    def responder_class
      klass = responders.find do |const|
        responder = Object.const_get"#{namespace}::#{const}"
        responder.instance_methods.include? step.to_sym
      end

      Object.const_get "#{namespace}::#{klass || 'BaseResponder'}"
    end
  end
end
