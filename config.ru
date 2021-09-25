# frozen_string_literal: true

require_relative 'config/application'

Application.initialize!

if ARGV.include? 'console'
  binding.pry
  return
end

Application.telegram_bot.call
