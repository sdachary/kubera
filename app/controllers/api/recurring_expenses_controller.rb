class Api::RecurringExpensesController < Api::BaseController
  def index
    expenses = storage.list_recurring_expenses
    render_success(expenses.map { |e| expense_json(e) })
  end

  def show
    expense = storage.get_recurring_expense(id: params[:id])
    render_success(expense_json(expense))
  end

  def create
    expense = storage.create_recurring_expense(attrs: expense_params)
    render_success(expense_json(expense), status: :created)
  end

  def update
    expense = storage.update_recurring_expense(id: params[:id], attrs: expense_params)
    render_success(expense_json(expense))
  end

  def destroy
    storage.delete_recurring_expense(id: params[:id])
    head :no_content
  end

  def calendar
    expenses = if params[:id]
                 [storage.get_recurring_expense(id: params[:id])]
               else
                 storage.list_recurring_expenses
               end
    render_success({ expenses: expenses.map { |e| expense_json(e) } })
  end

  private

  def expense_params
    source = params[:recurring_expense].presence || params
    source.permit(:name, :amount, :frequency, :next_due_date, :category,
                  :auto_debit, :active, :notes, :currency_code)
  end

  def expense_json(e)
    cc = e.currency_code.presence || "INR"
    { id: e.id, name: e.name, amount: e.amount.to_f, frequency: e.frequency,
      next_due_date: e.next_due_date, next_due_days: nil,
      monthly_amount: e.amount.to_f, category: e.category,
      auto_debit: e.auto_debit, active: e.active, notes: e.notes,
      created_at: e.created_at, currency_code: cc,
      currency_symbol: Currency.symbol_for(cc) }
  end
end
