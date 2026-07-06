class Api::BudgetsController < Api::BaseController
  def index
    budgets = storage.list_budgets
    render_success(budgets.map { |b| budget_json(b) })
  end

  def show
    budget = storage.get_budget(id: params[:id])
    render_success(budget_json(budget))
  end

  def create
    budget = storage.create_budget(attrs: budget_params)
    render_success(budget_json(budget), status: :created)
  end

  def update
    budget = storage.update_budget(id: params[:id], attrs: budget_params)
    render_success(budget_json(budget))
  end

  def destroy
    storage.delete_budget(id: params[:id])
    head :no_content
  end

  def overview
    budgets = storage.list_budgets
    render_success(budgets.map { |b| budget_detail(b) })
  end

  private

  def budget_params
    source = params[:budget].presence || params
    source.permit(:budget_category_id, :monthly_limit, :currency_code,
                  :period, :start_date, :end_date, :notes, :household_id)
  end

  def budget_json(b)
    { id: b.id, budget_category_id: b.budget_category_id,
      category_name: b.budget_category_id, monthly_limit: b.monthly_limit.to_f,
      currency_code: b.currency_code.presence || "INR",
      period: b.period, start_date: b.start_date, end_date: b.end_date,
      created_at: b.created_at }
  end

  def budget_detail(b)
    budget_json(b).merge(spent: 0.0, remaining: b.monthly_limit.to_f, usage_pct: 0.0, on_track: true)
  end
end
