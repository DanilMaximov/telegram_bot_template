# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'zeitwerk'
require 'singleton'
require 'forwardable'

class Application
  include Singleton

  def initialize!
    load_gems
    load_envs
    load_initializers
    load_app
  end

  def reload!
    loader.reload
  end

  def env
    @env ||= ENV['ENV'] || 'development'
  end

  def loader
    @loader ||= Zeitwerk::Loader.new
  end

  def load_gems
    Bundler.require(:default, env)
  end

  def load_envs
    ::Dotenv.load(".env.#{env}")
  end

  def load_initializers
    Dir['config/initializers/*.rb'].each do |file|
      require "./#{file}"
    end
  end

  def load_app
    # loader.logger = Logger.new($stderr)
    loader.push_dir('app/bot')
    loader.push_dir('app/helpers')
    loader.push_dir('app/models')
    loader.push_dir('app/services')
    loader.enable_reloading
    loader.setup
  end

  def telegram_bot
    TelegramBot
  rescue => exception
    raise exception if Application.env != 'production'

    Sentry.capture_exception(exception)
  end

  class << self
    extend Forwardable
    def_delegators :instance, *Application.instance_methods(false)
  end

  class TelegramBot
    require 'telegram/bot'

    def self.call
      ::Telegram::Bot::Client.run(ENV['TELEGRAM_TOKEN'], logger: Logger.new($stderr)) do |bot|
        bot.listen do |message|
          ::TelegramBot.new(bot: bot, message: message).call
        end
      rescue ::Telegram::Bot::Exceptions::Base => exception
        raise exception if Application.env != 'production'

        Sentry.capture_exception(exception)
      end
    end
  end
end
