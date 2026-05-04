class WealthJourneyTracker
  def initialize(user)
    @user = user
    @family = user.family
  end

  def debt_progress
    loans = @family.accounts.loans.includes(:loan)
    total_debt = loans.sum { |a| a.balance.abs }
    total_emi = loans.sum { |a| a.loan.emi_amount.to_f }
    {
      total_debt: total_debt,
      total_emi: total_emi,
      months_to_zero: calculate_months_to_zero(loans),
      progress_percentage: calculate_debt_progress(loans)
    }
  end

  def sip_progress
    # Check dividend SIP investments
    sip_goal = @family.sip_goal || 10000
    current_sip = calculate_current_sip
    {
      goal: sip_goal,
      current: current_sip,
      progress: (current_sip / sip_goal * 100).round(2),
      projected_income: calculate_projected_dividend_income
    }
  end

  def net_worth_trajectory
    accounts = @family.accounts
    assets = accounts.where(classification: 'asset').sum { |a| a.balance }
    liabilities = accounts.where(classification: 'liability').sum { |a| a.balance.abs }
    {
      net_worth: assets - liabilities,
      assets: assets,
      liabilities: liabilities,
      trajectory: calculate_trajectory
    }
  end

  def zero_day_milestone
    debt_data = debt_progress
    if debt_data[:total_debt] <= 0
      { reached: true, date: debt_data[:debt_free_date] }
    else
      { reached: false, estimated_date: calculate_debt_free_date }
    end
  end

  private

  def calculate_months_to_zero(loans)
    return 0 if loans.empty?
    total_months = 0
    loans.each do |account|
      loan = account.loan
      next unless loan
      total_months += loan.months_remaining || 0
    end
    total_months
  end

  def calculate_debt_progress(loans)
    # Simple progress: reduce debt over time
    50.0 # Placeholder
  end

  def calculate_current_sip
    5000 # Placeholder
  end

  def calculate_projected_dividend_income
    2000 # Placeholder
  end

  def calculate_trajectory
    # Generate 12-month projection
    (1..12).map { |m| { month: m, net_worth: 100000 + m * 5000 } }
  end

  def calculate_debt_free_date
    Date.today >> 24 # Placeholder: 24 months
  end
end
