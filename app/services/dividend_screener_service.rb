class DividendScreenerService
  DEFAULT_CANDIDATES = %w[RELIANCE.NS TCS.NS HDFCBANK.NS INFY.NS ITC.NS HINDUNILVR.NS]
  INDIAN_ETF_CANDIDATES = %w[NIFTYBEES.NS JUNIORBEES.NS]

  def initialize(provider: nil)
    @provider = provider || Providers::YahooFinanceAdapter.new
  end

  def screen(target_income: nil, risk_tolerance: "moderate")
    candidates = fetch_candidates
    screened = candidates.map { |s| enrich(s) }.compact

    screened = screened.select { |s| s[:yield] >= 0.5 }  # min 0.5% yield
    screened = screened.sort_by { |s| -score(s) }

    if target_income
      required_capital = target_income / (screened.first[:yield] / 100.0) rescue 0
      screened.first[:required_capital] = required_capital.round(2)
    end

    screened.first(5)
  end

  def suggest_dividend_stocks(monthly_investment: 5000, years: 10)
    target_income = monthly_investment * 12 * years * 0.06
    results = screen(target_income: target_income)

    results.each do |r|
      shares = monthly_investment / r[:price] rescue 0
      r[:monthly_shares] = shares.round(2)
      r[:projected_monthly_income] = ((r[:annual_dividend] / 12) * shares).round(2)
    end

    { stocks: results, target_income: target_income.round(2) }
  end

  private

  def fetch_candidates
    stocks = DEFAULT_CANDIDATES.map { |s| { symbol: s } }
    stocks + INDIAN_ETF_CANDIDATES.map { |s| { symbol: s } }
  end

  def enrich(stock)
    quote = @provider.fetch_quote(stock[:symbol])
    return nil unless quote && quote[:price].to_f > 0

    div = @provider.fetch_dividend(stock[:symbol])
    stock.merge(
      price: quote[:price],
      currency: quote[:currency] || "INR",
      annual_dividend: div ? div[:annual_dividend] : 0,
      yield: div ? div[:yield] : 0,
      previous_close: quote[:previous_close],
      name: stock[:name]
    )
  end

  def score(stock)
    score = 0.0
    score += stock[:yield] * 60    # yield is 60% of score
    score += stock[:annual_dividend] / stock[:price] * 100 * 40  # dividend growth proxy
    score
  end
end
