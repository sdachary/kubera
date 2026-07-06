class StorageProvider::LocalDatabase < StorageProvider
  def name
    "local"
  end

  def connected?
    true
  end

  def list_transactions(filters: {})
    scope = user.transactions.order(transaction_date: :desc)
    scope = scope.where(budget_category_id: filters[:budget_category_id]) if filters[:budget_category_id]
    scope = scope.where(transaction_type: filters[:transaction_type]) if filters[:transaction_type]
    scope = scope.where("transaction_date >= ?", filters[:start_date]) if filters[:start_date]
    scope = scope.where("transaction_date <= ?", filters[:end_date]) if filters[:end_date]
    scope = scope.uncategorized if filters[:uncategorized]
    scope
  end

  def get_transaction(id:)
    user.transactions.find(id)
  end

  def create_transaction(attrs:)
    user.transactions.create!(attrs)
  end

  def update_transaction(id:, attrs:)
    user.transactions.find(id).tap { |t| t.update!(attrs) }
  end

  def delete_transaction(id:)
    user.transactions.find(id).destroy!
  end

  def list_debts(filters: {})
    scope = user.debts.order(created_at: :desc)
    scope = scope.active if filters[:active]
    scope
  end

  def get_debt(id:)
    user.debts.find(id)
  end

  def create_debt(attrs:)
    user.debts.create!(attrs)
  end

  def update_debt(id:, attrs:)
    user.debts.find(id).tap { |d| d.update!(attrs) }
  end

  def delete_debt(id:)
    user.debts.find(id).destroy!
  end

  def list_portfolios(filters: {})
    user.portfolios.order(created_at: :desc)
  end

  def get_portfolio(id:)
    user.portfolios.find(id)
  end

  def create_portfolio(attrs:)
    user.portfolios.create!(attrs)
  end

  def update_portfolio(id:, attrs:)
    user.portfolios.find(id).tap { |p| p.update!(attrs) }
  end

  def delete_portfolio(id:)
    user.portfolios.find(id).destroy!
  end

  def list_investments(filters: {})
    scope = user.investments.order(created_at: :desc)
    scope = scope.where(portfolio_id: filters[:portfolio_id]) if filters[:portfolio_id]
    scope
  end

  def get_investment(id:)
    user.investments.find(id)
  end

  def create_investment(attrs:)
    user.investments.create!(attrs)
  end

  def update_investment(id:, attrs:)
    user.investments.find(id).tap { |i| i.update!(attrs) }
  end

  def delete_investment(id:)
    user.investments.find(id).destroy!
  end

  def list_budgets(filters: {})
    user.budgets.includes(:budget_category).order(created_at: :desc)
  end

  def get_budget(id:)
    user.budgets.find(id)
  end

  def create_budget(attrs:)
    user.budgets.create!(attrs)
  end

  def update_budget(id:, attrs:)
    user.budgets.find(id).tap { |b| b.update!(attrs) }
  end

  def delete_budget(id:)
    user.budgets.find(id).destroy!
  end

  def list_budget_categories(filters: {})
    user.budget_categories.order(sort_order: :asc)
  end

  def get_budget_category(id:)
    user.budget_categories.find(id)
  end

  def create_budget_category(attrs:)
    user.budget_categories.create!(attrs)
  end

  def update_budget_category(id:, attrs:)
    user.budget_categories.find(id).tap { |c| c.update!(attrs) }
  end

  def delete_budget_category(id:)
    user.budget_categories.find(id).destroy!
  end

  def list_recurring_expenses(filters: {})
    scope = user.recurring_expenses.order(created_at: :desc)
    scope
  end

  def get_recurring_expense(id:)
    user.recurring_expenses.find(id)
  end

  def create_recurring_expense(attrs:)
    user.recurring_expenses.create!(attrs)
  end

  def update_recurring_expense(id:, attrs:)
    user.recurring_expenses.find(id).tap { |r| r.update!(attrs) }
  end

  def delete_recurring_expense(id:)
    user.recurring_expenses.find(id).destroy!
  end

  def list_net_worth_snapshots(filters: {})
    user.net_worth_snapshots.order(snapshot_date: :desc)
  end

  def get_net_worth_snapshot(id:)
    user.net_worth_snapshots.find(id)
  end

  def list_trips(filters: {})
    user.trips.order(created_at: :desc)
  end

  def get_trip(id:)
    user.trips.find(id)
  end

  def create_trip(attrs:)
    user.trips.create!(attrs)
  end

  def update_trip(id:, attrs:)
    user.trips.find(id).tap { |t| t.update!(attrs) }
  end

  def delete_trip(id:)
    user.trips.find(id).destroy!
  end

  def list_trip_expenses(filters: {})
    scope = user.trip_expenses.order(created_at: :desc)
    scope = scope.where(trip_id: filters[:trip_id]) if filters[:trip_id]
    scope
  end

  def create_trip_expense(attrs:)
    user.trip_expenses.create!(attrs)
  end

  def update_trip_expense(id:, attrs:)
    user.trip_expenses.find(id).tap { |e| e.update!(attrs) }
  end

  def delete_trip_expense(id:)
    user.trip_expenses.find(id).destroy!
  end
end
