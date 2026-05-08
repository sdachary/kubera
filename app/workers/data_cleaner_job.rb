class DataCleanerJob
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority, retry: 3

  def perform(*args)
    Rails.logger.info "[DataCleanerJob] Starting scheduled task"
  end
end
