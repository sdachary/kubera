class ImportMarketDataWorker
  include Sidekiq::Worker
  sidekiq_options queue: :scheduled, retry: 3, backtrace: true

  def perform(*args)
    securities = Security.where.not(isin: nil)
    provider = Providers::YahooFinanceAdapter.new

    securities.each do |security|
      quote = provider.fetch_quote(security.ticker)
      next unless quote && quote[:price].to_f > 0

      SecurityPrice.upsert(
        {
          security_id: security.id,
          date: Date.current,
          price: quote[:price],
          currency: quote[:currency] || "USD",
          isin: security.isin
        },
        unique_by: [:security_id, :date, :currency]
      )

      security.update!(last_synced_at: Time.current) if security.respond_to?(:last_synced_at)
    rescue => e
      Rails.logger.warn "[MarketData] Failed for #{security.ticker}: #{e.message}"
    end
  end
end
