Sentry.init do |config|
  config.dsn = 'DSN'

  config.traces_sample_rate = 0.2
  config.transport.open_timeout = 10
  config.transport.timeout = 10
end
