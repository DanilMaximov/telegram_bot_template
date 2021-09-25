# frozen_string_literal: true

module Responders
  class ResponderClassService < ApplicationService
    param :role
    param :step

    BASE = 'Base'

    def call
      Object.const_get "Dispatcher::#{role.capitalize}::#{step_group || BASE}Responder"
    end

    private

    def step_group
      responder_steps.select { |_, v| v.value?(step) }.keys[0]&.capitalize
    end

    def responder_steps
      I18n.t("system.responders.#{role}.steps")
    end
  end
end
