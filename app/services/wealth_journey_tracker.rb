class WealthJourneyTracker
  def initialize(user)
    @user = user
  end

  def debt_progress
    debts = Debt.all
    total_debt = debts.sum(&:amount)
    total_emi = debts.sum(&:emi_amount)
    {
      total_debt: total_debt,
      total_emi: total_emi,
      months_to_zero: debts.map(&:months_remaining).max || 0,
      progress_percentage: 25.0 # Placeholder
    }
  end

  def sip_progress
    investments = Investment.all
    {
      goal: 50000,
      current: 15000,
      progress: 30.0,
      projected_income: 2500
    }
  end

  def net_worth_trajectory
    total_debt = Debt.sum(:amount)
    # Use DebtPayoffService for a more accurate trajectory if needed
    # For now, keeping the simple placeholder logic
    {
      net_worth: 500000 - total_debt,
      assets: 500000,
      liabilities: total_debt,
      trajectory: (1..12).map { |m| { month: m, net_worth: (500000 - total_debt) + m * 10000 } }
    }
  end

  def zero_day_milestone
    { reached: false, estimated_date: Date.today >> 12 }
  end
end
