# frozen_string_literal: true

module Dispatcher
  class Base < SuperBase
    param :user, Types::Instance(::User)

    def self.call(*args, **options)
      new(*args, **options).call
    end

    def call
      send(message[:method])
    end
  end
end
