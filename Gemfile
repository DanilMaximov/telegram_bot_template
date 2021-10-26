# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.2'

gem 'rack'

# bots
gem 'telegram-bot-ruby'

# db
gem 'pg', require: false
gem 'sequel', '~> 5.42', require: false
gem 'sequel_pg', require: 'sequel'

# environment config
gem 'dotenv'
gem 'i18n'
gem 'require_all'

# redis
gem 'connection_pool', '~> 2.2' # for managing Redis connections
gem 'redis', '~> 3.3'
gem 'redis-namespace', '~> 1.5' # allows namespacing Redis keys

# utilities
gem 'aasm', '5.0.6', require: false # state machine
gem 'chronic_duration' # parse strings like '4h', '3 days', etc.
gem 'dry-configurable', '~> 0.11', require: false
gem 'dry-initializer', '~> 3.0', require: false
gem 'dry-struct'
gem 'dry-types', require: false
gem 'dry-validation', '~> 1.6', require: false
gem 'hashie', '~> 3.5.7' # better hashes
gem 'inline_svg' # inline SVG
gem 'parse-cron', '~> 0.1.4' # Parse cron entries
gem 'sentry-ruby'
gem 'http'
gem 'zeitwerk'

# sidekiq
gem 'async'
gem 'sidekiq', '~> 5.2.9'
gem 'sidekiq-status'

group :development, :test do
  # better console
  gem 'pry-byebug'
  gem 'pry-inline'
  gem 'pry-theme'

  gem 'guard'
  gem 'guard-rspec', '4.7.3'
  gem 'guard-rubocop'
end

group :test do
  gem 'database_cleaner', '1.8.3'
  gem 'factory_bot', '~> 6.1'
  gem 'faker'
  gem 'simplecov', require: false

  # mocking
  gem 'timecop', require: false
  gem 'webmock', require: false

  # formatters
  gem 'fuubar'
  gem 'rspec_junit_formatter'

  # utilities
  gem 'private_address_check', require: false
end

group :development do
  # linting
  gem 'rubocop', '~> 0.89', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
end
