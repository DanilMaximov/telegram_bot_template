# frozen_string_literal: true

require 'dry-initializer'

class ApplicationBot
  extend Dry::Initializer

  option :bot, optional: true
  option :message, optional: true
  option :parse_mode, default: -> { 'HTML' }


  BUTTON = 'button'
  TEXT = 'text'
  COMMAND = 'command'

  USER = 'user'
  ADMIN = 'admin'
  MODERATOR = 'moderator'

  COMMAND_START = '/start'

  START = 'start'

  def call(**)
    raise NotImplementedError, '#call is not implemented'
  end

  def authenticate_user!
    raise NotImplementedError, '#authenticate_user! is not implemented'
  end

  def send_message(**)
    raise NotImplementedError, '#send_message! is not implemented'
  end

  def edit_message(**)
    raise NotImplementedError, '#edit_message! is not implemented'
  end
end
