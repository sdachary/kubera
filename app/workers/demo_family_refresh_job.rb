class DemoFamilyRefreshJob
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority, retry: 3

  def perform(*args)
    Rails.logger.info "[DemoFamilyRefreshJob] Starting scheduled task"
  end
end
