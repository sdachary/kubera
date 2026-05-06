class DividendSip::SipCalculatorComponent < ViewComponent::Base
  def initialize(monthly_investment: 5000, expected_return_rate: 12.0, time_period_years: 10, existing_data: nil)
    @monthly_investment = monthly_investment.to_f
    @expected_return_rate = expected_return_rate.to_f
    @time_period_years = time_period_years.to_i
    @existing_data = existing_data || default_sip_data
  end

  def total_investment
    @monthly_investment * 12 * @time_period_years
  end

  def estimated_returns
    calculate_sip(@monthly_investment, @expected_return_rate, @time_period_years) - total_investment
  end

  def total_value
    calculate_sip(@monthly_investment, @expected_return_rate, @time_period_years)
  end

  def yearly_projection
    (1..@time_period_years).map do |year|
      invested = @monthly_investment * 12 * year
      value = calculate_sip(@monthly_investment, @expected_return_rate, year)
      {
        year: year,
        invested: invested.round(2),
        value: value.round(2),
        returns: (value - invested).round(2)
      }
    end
  end

  private

  def calculate_sip(monthly, rate, years)
    monthly_rate = rate / (12 * 100)
    months = years * 12
    monthly * ((1 + monthly_rate) ** months - 1) / monthly_rate * (1 + monthly_rate)
  end

  def default_sip_data
    [
      { fund_name: "HDFC Top 100 Fund", monthly: 5000, rating: 4 },
      { fund_name: "ICICI Prudential Bluechip Fund", monthly: 3000, rating: 5 },
      { fund_name: "SBI Large Cap Fund", monthly: 2000, rating: 4 }
    ]
  end
end
