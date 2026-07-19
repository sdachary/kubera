Sentry.init do |config|
  config.dsn = ENV.fetch('SENTRY_DSN_KUBERA_BACKEND', 'https://d603e9f539683904fcbac5d5714203e3@o4511755199774720.ingest.us.sentry.io/4511755227758592')
  config.enabled_environments = %w[production staging]
  config.traces_sample_rate = 0.2
end
