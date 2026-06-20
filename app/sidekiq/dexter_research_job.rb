class DexterResearchJob
  include Sidekiq::Job

  sidekiq_options retry: 3, queue: :default

  def perform(user_id, ticker, exchange = "US")
    user = User.find_by(id: user_id)
    return unless user

    service = DexterResearchService.new
    report = service.full_report(ticker: ticker, exchange: exchange)

    Rails.logger.info "[Dexter] Researched #{ticker} (#{exchange}) for user #{user_id}: #{report[:error] ? "failed - #{report[:error]}" : "ok"}"
  rescue StandardError => e
    Rails.logger.error "[Dexter] Research job failed for #{ticker}: #{e.message}"
    raise
  end
end
