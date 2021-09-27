# frozen_string_literal: true

module Dispatcher
  module Validating
    def validate!
      has_access? && !start_message?
    end

    private

    def has_access?
      user.access || user.admin?
    end

    def start_message?
      if message[:type] == :text && message[:content] == client.invocation_command
        user.start!

        force_message(step: client.initial_step)

        true
      end
    end
  end
end
