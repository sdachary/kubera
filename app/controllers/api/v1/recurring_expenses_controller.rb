class Api::V1::RecurringExpensesController < Api::V1::BaseController
  before_action :set_expense, only: [:show, :update, :destroy, :calendar]

  def index
    @expenses = RecurringExpense.all
    render json: @expenses
  end

  def show
    render json: @expense
  end

  def create
    @expense = RecurringExpense.new(expense_params)
    if @expense.save
      render json: @expense, status: :created
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head :no_content
  end

  def calendar
    month = params[:month].to_i
    year = params[:year].to_i
    expenses = @expense ? [@expense] : RecurringExpense.all

    calendar_data = expenses.map do |expense|
      {
        id: expense.id,
        name: expense.name,
        amount: expense.amount,
        frequency: expense.frequency,
        next_due_date: expense.next_due_date,
        due_dates: calculate_due_dates(expense, month, year)
      }
    end

    render json: { expenses: calendar_data }
  end

  private

  def set_expense
    @expense = RecurringExpense.find(params[:id])
  end

  def expense_params
    params.require(:recurring_expense).permit(:name, :amount, :frequency, :next_due_date, :category, :auto_debit)
  end

  def calculate_due_dates(expense, month, year)
    # Calculate all due dates for the given month
    dates = []
    current = expense.next_due_date
    return dates unless current

    while current.month == month && current.year == year
      dates << current
      current = case expense.frequency
                when 'daily'
                  current + 1.day
                when 'weekly'
                  current + 1.week
                when 'monthly'
                  current + 1.month
                when 'yearly'
                  current + 1.year
                else
                  break
                end
    end
    dates
  end
end
