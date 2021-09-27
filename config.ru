# frozen_string_literal: true

require_relative 'config/application'

Application.initialize!

if ARGV.include? 'console'
  Pry.start
  return
end

Application.telegram_bot.call
