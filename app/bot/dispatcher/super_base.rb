# frozen_string_literal: true

module Dispatcher
  class SuperBase
    extend Dry::Initializer

    param :user, Types::Instance(::User)
    option :message
    option :client
    option :force_step, optional: true

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

    def responder_class(role = user.role, step = nil)
      step ||= message[:content][:step] || user.step

      namespace = Object.const_get "Dispatcher::#{role.capitalize}"

      responders = namespace.constants.filter { |responder| responder.to_s.include? 'Responder' }
      
      klass = responders.find do |const|
        responder = Object.const_get"#{namespace}::#{const}"
        responder.instance_methods.include? step.to_sym
      end

      Object.const_get "#{namespace}::#{klass || 'BaseResponder'}"
    end
  end
end
