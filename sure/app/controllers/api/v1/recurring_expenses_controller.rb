class Api::V1::RecurringExpensesController < Api::V1::BaseController
  before_action :ensure_read_scope, only: [:index]
  before_action :ensure_write_scope, only: [:create, :update, :destroy, :notify]

  def index
    @expenses = current_resource_owner.recurring_expenses.active
    render json: @expenses
  end

  def create
    @expense = current_resource_owner.recurring_expenses.build(recurring_expense_params)
    if @expense.save
      render json: @expense, status: :created
    else
      render json: { errors: @expense.errors }, status: :unprocessable_entity
    end
  end

  def update
    @expense = current_resource_owner.recurring_expenses.find(params[:id])
    if @expense.update(recurring_expense_params)
      render json: @expense
    else
      render json: { errors: @expense.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @expense = current_resource_owner.recurring_expenses.find(params[:id])
    @expense.update(active: false)
    head :no_content
  end

  def notify
    overdue = current_resource_owner.recurring_expenses.where('next_due_date < ?', Date.today)
    # Send notifications here
    render json: { overdue_count: overdue.count }
  end

  private

  def recurring_expense_params
    params.require(:recurring_expense).permit(:amount, :frequency, :next_due_date, :category, :account_id)
  end

  def ensure_read_scope
    authorize_scope!(:read)
  end

  def ensure_write_scope
    authorize_scope!(:write)
  end
end
