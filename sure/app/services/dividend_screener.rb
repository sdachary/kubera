class DividendScreener
  def initialize(monthly_investment:, target_income:)
    @monthly_investment = monthly_investment.to_f
    @target_income = target_income.to_f
  end

  def suggest_stocks
    # Placeholder: integrate with NSE/BSE API
    [
      { symbol: "INFY", name: "Infosys", dividend_yield: 2.5, risk: "low" },
      { symbol: "TCS", name: "Tata Consultancy", dividend_yield: 1.8, risk: "low" },
      { symbol: "HDFC", name: "HDFC Bank", dividend_yield: 1.2, risk: "medium" }
    ]
  end

  def calculate_sip_timeline
    months_needed = (@target_income * 12) / (@monthly_investment * 0.02)
    {
      months: months_needed.ceil,
      projected_income: @monthly_investment * months_needed * 0.02 / 12
    }
  end
end
