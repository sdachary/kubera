if defined?(Sidekiq::Cron)
  Sidekiq::Cron::Job.create_or_update(
    name: "Import Market Data — daily after market close",
    cron: "30 21 * * 1-5", # 4:30 PM EST weekdays → ~9:30 PM UTC
    class: "ImportMarketDataWorker"
  )

  Sidekiq::Cron::Job.create_or_update(
    name: "Exchange Rate Sync — every 6 hours",
    cron: "0 */6 * * *",
    class: "ExchangeRateSyncWorker"
  )

  Sidekiq::Cron::Job.create_or_update(
    name: "Security Health Check — daily 2 AM",
    cron: "0 2 * * *",
    class: "SecurityHealthCheckJob"
  )

  Sidekiq::Cron::Job.create_or_update(
    name: "Sync Cleaner — every hour",
    cron: "0 * * * *",
    class: "SyncCleanerJob"
  )

  Sidekiq::Cron::Job.create_or_update(
    name: "Data Cleaner — daily 3 AM",
    cron: "0 3 * * *",
    class: "DataCleanerJob"
  )
end
