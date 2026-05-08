class SyncHourlyJob
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority, retry: 3

  def perform(*args)
    Rails.logger.info "[SyncHourlyJob] Starting scheduled task"
  end
end
