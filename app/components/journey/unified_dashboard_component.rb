class Journey::UnifiedDashboardComponent < ViewComponent::Base
  def initialize(debts: [], investments: [], net_worth_history: [])
    @debts = debts || []
    @investments = investments || []
    @net_worth_history = net_worth_history || []
  end

  def total_debt
    @debts.sum { |d| d.amount || 0 }
  end

  def total_investments
    # Summing up some placeholder value if current_value is not present
    @investments.sum { |i| i.respond_to?(:current_value) ? i.current_value : (i.respond_to?(:amount) ? i.amount : 0) }
  end

  def net_worth
    total_investments - total_debt
  end

  def debt_free_date
    @debts.map { |d| d.respond_to?(:debt_free_date) ? d.debt_free_date : (Date.today + 1.year) }.max || Date.today
  end

  def payoff_progress
    return 100 if total_debt == 0
    # Placeholder for progress calculation
    45
  end
end
