# frozen_string_literal: true

module Dispatcher
  class Base < SuperBase
    option :skip_validation, Types::Bool, default: -> { false }

    include Responding
    include Validating

    def self.call(*args, **options)
      new(*args, **options).call
    end

    def call
      return unless validate! || skip_validation

      case message[:type]
      when :button then button_respond
      when :text then text_respond
      end
    end

    protected

    def text_respond
      send(force_step || user.step)
    end

    def button_respond
      send("button_#{message[:content][:text].downcase}")
    end
  end
end
