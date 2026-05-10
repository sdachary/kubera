class GoalChartService
  def initialize(user)
    @user = user
  end

  def debt_free_progress
    debts = @user.debts.active
    return [] if debts.empty?

    total = debts.sum(&:amount)
    paid = debts.sum(&:paid_amount)
    remaining = total - paid

    months = debts.map(&:months_remaining).compact.max || 0
    monthly_emi = debts.sum(&:emi_amount)

    projection = (0..[months, 60].min).map do |m|
      month_date = Date.today + m.months
      paid_so_far = monthly_emi * m
      {
        month: month_date.strftime("%Y-%m"),
        label: month_date.strftime("%b %Y"),
        remaining: [remaining - paid_so_far, 0].max.round(2),
        target: 0
      }
    end

    {
      total_debt: total.to_f,
      paid_so_far: paid.to_f,
      remaining: remaining.to_f,
      progress_pct: total > 0 ? (paid / total * 100).round(1) : 0,
      projection: projection
    }
  end

  def wealth_growth
    current_nw = NetWorthSnapshot.current(@user)
    monthly_sip = DividendSip.where(status: "active").sum(&:monthly_contribution)

    (0..30).map do |year|
      year_date = Date.today + year.years
      projected = current_nw.net_worth.to_f * (1.10 ** year)
      projected += monthly_sip * 12 * year * (1.05 ** year)

      {
        year: year_date.year,
        label: year_date.year.to_s,
        projected: projected.round(2),
        conservative: (current_nw.net_worth.to_f * (1.07 ** year)).round(2),
        aggressive: (current_nw.net_worth.to_f * (1.12 ** year)).round(2)
      }
    end
  end

  def monthly_budget_chart
    BudgetCategory.where(user: @user).active.map do |cat|
      spent = cat.monthly_spending(@user.id)
      limit = cat.budgets.active.first&.monthly_limit

      {
        category: cat.name,
        spent: spent.to_f,
        budgeted: limit.to_f,
        remaining: (limit.to_f - spent.to_f).round(2),
        color: cat.color
      }
    end
  end

  def income_vs_expenses(months: 12)
    Transaction.monthly_totals(@user.id, months: months)
  end
end
