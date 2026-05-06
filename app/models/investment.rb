class Investment < ApplicationRecord
  # symbol, name, dividend_yield, risk_level
  
  def calculate_sip(monthly_amount, years)
    # Placeholder for SIP calculation
    {
      total_invested: monthly_amount * 12 * years,
      projected_value: monthly_amount * 12 * years * 1.1 # 10% growth placeholder
    }
  end

  def project_income(monthly_sip)
    # Placeholder for income projection
    monthly_sip * (dividend_yield / 100.0)
  end
end
