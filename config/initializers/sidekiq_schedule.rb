if defined?(Sidekiq::Cron)
  begin
    Sidekiq.redis(&:ping)
  rescue => e
    Rails.logger.warn("Sidekiq cron init skipped: Redis unavailable (#{e.message})")
    return
  end

  jobs = [
    { name: "Import Market Data — daily after market close", cron: "30 21 * * 1-5", class: "ImportMarketDataWorker" },
    { name: "Exchange Rate Sync — every 6 hours", cron: "0 */6 * * *", class: "ExchangeRateSyncWorker" },
    { name: "Security Health Check — daily 2 AM", cron: "0 2 * * *", class: "SecurityHealthCheckJob" },
    { name: "Sync Cleaner — every hour", cron: "0 * * * *", class: "SyncCleanerJob" },
    { name: "Data Cleaner — daily 3 AM", cron: "0 3 * * *", class: "DataCleanerJob" },
    { name: "Expense Reminder Check — daily 9 AM", cron: "0 9 * * *", class: "ExpenseReminderCheckJob" },
  ]

  jobs.each do |attrs|
    job = Sidekiq::Cron::Job.find(attrs[:name])
    job&.destroy
    Sidekiq::Cron::Job.create(name: attrs[:name], cron: attrs[:cron], class: attrs[:class])
  end
end
