class DexterResearchService
  def initialize(dexter: Dexter::Wrapper.new)
    @dexter = dexter
  end

  def analyze_company(ticker:, exchange: "US")
    dexter_research(ticker, exchange) do
      {
        company: @dexter.analyze_company(ticker: ticker, exchange: exchange),
        ratios: @dexter.financial_ratios(ticker: ticker, exchange: exchange),
      }
    end
  end

  def full_report(ticker:, exchange: "US")
    dexter_research(ticker, exchange) do
      {
        company: @dexter.analyze_company(ticker: ticker, exchange: exchange),
        ratios: @dexter.financial_ratios(ticker: ticker, exchange: exchange),
        income: @dexter.income_statement(ticker: ticker, exchange: exchange),
        balance: @dexter.balance_sheet(ticker: ticker, exchange: exchange),
        cashflow: @dexter.cash_flow(ticker: ticker, exchange: exchange),
      }
    end
  end

  private

  def dexter_research(ticker, exchange)
    result = yield
    { ticker: ticker, exchange: exchange, **result, researched_at: Time.current }
  rescue StandardError => e
    { ticker: ticker, exchange: exchange, error: e.message, researched_at: Time.current }
  end
end
