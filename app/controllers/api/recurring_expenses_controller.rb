class Api::RecurringExpensesController < Api::BaseController
  def index
    expenses = current_user.recurring_expenses.order(next_due_date: :asc)
    render json: expenses.map { |e| expense_json(e) }
  end

  def create
    expense = current_user.recurring_expenses.create!(expense_params)
    render json: expense_json(expense), status: :created
  end

  def update
    expense = current_user.recurring_expenses.find(params[:id])
    expense.update!(expense_params)
    render json: expense_json(expense)
  end

  def destroy
    expense = current_user.recurring_expenses.find(params[:id])
    expense.destroy!
    head :no_content
  end

  private

  def expense_params
    params.permit(:name, :amount, :frequency, :next_due_date, :category,
                  :auto_debit, :active, :notes)
  end

  def expense_json(e)
    { id: e.id, name: e.name, amount: e.amount.to_f, frequency: e.frequency,
      next_due_date: e.next_due_date, next_due_days: e.next_due_days,
      monthly_amount: e.monthly_amount.to_f, category: e.category,
      auto_debit: e.auto_debit, active: e.active, notes: e.notes,
      created_at: e.created_at }
  end
end
