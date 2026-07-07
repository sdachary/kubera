class DexterResearchJob
  include Sidekiq::Job

  sidekiq_options retry: 3, queue: :default

  def perform(portfolio_id, ticker, exchange = "US")
    portfolio = Portfolio.find_by(id: portfolio_id)
    return unless portfolio

    analysis = portfolio.research_analyses.find_or_initialize_by(ticker: ticker, exchange: exchange)
    analysis.update!(status: "processing")

    service = DexterResearchService.new
    report = service.full_report(ticker: ticker, exchange: exchange)

    if report[:error]
      analysis.update!(
        status: "failed",
        error_message: report[:error],
        researched_at: Time.current
      )
      Rails.logger.warn "[Dexter] Research failed for #{ticker}: #{report[:error]}"
    else
      company = report[:company]
      ratios = report[:ratios]

      analysis.update!(
        status: "completed",
        company_name: company&.dig(:data, "company_name"),
        sector: company&.dig(:data, "sector"),
        summary: company&.dig(:data, "summary"),
        ratios_data: ratios&.dig(:data, "ratios"),
        statements_data: company&.dig(:data, "statements"),
        researched_at: Time.current,
        error_message: nil
      )
      Rails.logger.info "[Dexter] Research completed for #{ticker}"
    end
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn "[Dexter] Portfolio #{portfolio_id} not found"
  rescue StandardError => e
    analysis&.update!(status: "failed", error_message: e.message, researched_at: Time.current)
    Rails.logger.error "[Dexter] Research job failed for #{ticker}: #{e.message}"
    raise
  end
end
