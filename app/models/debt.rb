class Debt < ApplicationRecord
  # amount, interest_rate, emi_amount, due_date, status
  
  def months_remaining
    return 0 if interest_rate <= 0 || emi_amount <= 0
    # Simple interest-based approximation for now
    (amount / emi_amount).ceil
  end

  def debt_free_date
    Date.today + months_remaining.months
  end

  def progress_percentage
    # For now, placeholder
    0.0
  end
end
