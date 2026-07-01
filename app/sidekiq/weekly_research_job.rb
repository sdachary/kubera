class WeeklyResearchJob
  include Sidekiq::Job

  sidekiq_options retry: 1, queue: :default

  def perform
    processed = 0

    Portfolio.find_each do |portfolio|
      portfolio.investments.where(investment_type: %w[stock etf]).find_each do |inv|
        DexterResearchJob.perform_async(portfolio.id, inv.symbol, inv.exchange || "US")
        processed += 1
      end
    end

    Rails.logger.info "[Dexter] Weekly research queued for #{processed} investments"
  end
end
