module Dispatcher
  module Concerns::ResponderRouter
    COMMAND_FORMAT = /\/\w*/

    protected

    def button_routing
      case message[:content][:tid]
      when *index_of(Constants::ACCEPT, Constants::DENY) then 'Auth'
      end
    end

    def command_routing
      case message[:content][:text]
      when '/start' then ['Base', 'start']
      end
    end

    def text_routing
      step = force_step || message.fetch(:content, :step) || @user.step

      responder = Object.const_get(namespace).constants.filter { _1.to_s.include? 'Responder' }
        .find { Object.const_get("#{namespace}::#{_1}").instance_methods.include?(step.to_sym) }
      &.chomp('Responder')

      [responder, step]
    end

    def index_of(*buttons)
      buttons.map do
        Constants::BUTTONS.index(_1)
      end
    end

    def namespace
      "Dispatcher::#{@user.role.capitalize}"
    end
  end
end
