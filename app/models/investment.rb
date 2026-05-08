class Investment < ApplicationRecord
  belongs_to :portfolio

  validates :investment_type, inclusion: {
    in: %w[stock etf mutual_fund bond other]
  }, allow_nil: true

  def current_value
    (shares || 0) * (current_price || 0)
  end

  def cost_basis
    (shares || 0) * (buy_price || 0)
  end

  def gain_loss
    current_value - cost_basis
  end

  def gain_loss_percentage
    return 0.0 if cost_basis <= 0
    (gain_loss / cost_basis * 100).round(2)
  end

  def projected_annual_income
    current_value * (dividend_yield || 0) / 100.0
  end
end
