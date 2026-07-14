class Budget < TenantRecord
  belongs_to :user
  belongs_to :budget_category
  belongs_to :household, optional: true

  validates :monthly_limit, numericality: { greater_than: 0 }
  validates :period, inclusion: { in: %w[weekly monthly quarterly yearly] }
  validates :currency_code, inclusion: { in: Currency::CURRENCY_SYMBOLS.keys }, allow_nil: true

  scope :active, -> { where("(start_date IS NULL OR start_date <= ?) AND (end_date IS NULL OR end_date >= ?)", Date.today, Date.today) }

  def spent_this_month
    budget_category.monthly_spending(user_id)
  end

  def remaining
    monthly_limit - spent_this_month
  end

  def usage_percentage
    return 0.0 if monthly_limit <= 0
    [(spent_this_month / monthly_limit * 100).round(1), 100.0].min
  end

  def on_track?
    return true if monthly_limit <= 0
    days_passed = Date.today.day
    days_in_month = Date.today.end_of_month.day
    expected_pct = (days_passed.to_f / days_in_month * 100)
    usage_percentage <= expected_pct * 1.2
  end
end
