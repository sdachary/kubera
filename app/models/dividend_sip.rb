class DividendSip < ApplicationRecord
  belongs_to :portfolio

  validates :amount, numericality: { greater_than: 0 }
  validates :frequency, inclusion: { in: %w[monthly quarterly yearly] }
  validates :status, inclusion: { in: %w[active paused completed] }

  def projected_annual_income(yield_rate = 0.04)
    monthly_contribution * 12 * yield_rate
  end

  def monthly_contribution
    case frequency
    when "monthly" then amount
    when "quarterly" then amount / 3.0
    when "yearly" then amount / 12.0
    else amount
    end
  end
end
