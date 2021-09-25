# frozen_string_literal: true

module Dispatcher
  class SuperBase
    extend Dry::Initializer

    param :user, Types::Instance(::User)
    option :message, optional: true
    option :client
    option :force_step, optional: true
    option :skip_validation, Types::Bool, default: -> { false }

    def self.dispatch(*args, **options)
      new(*args, **options).dispatch
    end

    def dispatch
      responder_class.call(
        user,
        message: message,
        client: client
      )
    end

    protected

    def responder_class(role = user.role, step = user.step)
      ::Responders::ResponderClassService.call(role, step)
    end
  end
end
