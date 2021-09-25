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
      if message[:type] == ::ApplicationBot::TEXT && message[:content] == ::ApplicationBot::COMMAND_START
        user.start!

        force_message(step: ::ApplicationBot::START)

        true
      end
    end
  end
end
