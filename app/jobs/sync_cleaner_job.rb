class SyncCleanerJob
  include Sidekiq::Job
  sidekiq_options queue: :low_priority, retry: 1

  def perform(*args)
    stale_rates = ExchangeRate.stale
    if stale_rates.any?
      ExchangeRateSyncJob.perform_async
      Rails.logger.info "[SyncCleaner] Queued exchange rate sync for #{stale_rates.count} stale rates"
    end
  end
end
