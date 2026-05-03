class DividendScreener
  STOCKS = [
    { symbol: "ITC.NS", name: "ITC Limited", dividend_yield: 3.8, risk: "low" },
    { symbol: "IOC.NS", name: "Indian Oil Corp", dividend_yield: 10.2, risk: "medium" },
    { symbol: "RECLTD.NS", name: "REC Limited", dividend_yield: 8.5, risk: "medium" },
    { symbol: "PFC.NS", name: "Power Finance Corp", dividend_yield: 8.2, risk: "medium" },
    { symbol: "COALINDIA.NS", name: "Coal India", dividend_yield: 9.1, risk: "low" },
    { symbol: "VEDL.NS", name: "Vedanta Limited", dividend_yield: 12.5, risk: "high" },
    { symbol: "HCLTECH.NS", name: "HCL Technologies", dividend_yield: 3.5, risk: "low" },
    { symbol: "TCS.NS", name: "TCS", dividend_yield: 2.1, risk: "low" },
    { symbol: "INFY.NS", name: "Infosys", dividend_yield: 2.4, risk: "low" },
    { symbol: "GAIL.NS", name: "GAIL (India)", dividend_yield: 4.2, risk: "medium" }
  ].freeze

  def initialize(monthly_investment:, target_income:)
    @monthly_investment = monthly_investment.to_f
    @target_income = target_income.to_f
  end

  def suggest_stocks
    # In a real app, this would fetch current data from a provider
    STOCKS.sample(5).sort_by { |s| -s[:dividend_yield] }
  end

  def calculate_sip_timeline
    avg_yield = suggest_stocks.sum { |s| s[:dividend_yield] } / 5.0 / 100.0
    
    # Simple formula: Target Annual Income / Avg Yield = Target Corpus
    target_corpus = (@target_income * 12) / avg_yield
    
    # How many months to reach target_corpus with monthly_investment (ignoring capital appreciation for simplicity)
    months_needed = target_corpus / @monthly_investment
    
    {
      months: months_needed.ceil,
      years: (months_needed / 12.0).round(1),
      target_corpus: target_corpus.round(2),
      avg_yield_percent: (avg_yield * 100).round(2),
      projected_income: @target_income
    }
  end
end
