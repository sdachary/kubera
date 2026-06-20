class TripExpensesController < ApplicationController
  before_action :set_trip

  def create
    @expense = @trip.trip_expenses.new(expense_params)
    @expense.expense_date ||= Date.current

    if @expense.save
      redirect_to @trip, notice: "Expense added."
    else
      redirect_to @trip, alert: @expense.errors.full_messages.to_sentence
    end
  end

  def update
    @expense = @trip.trip_expenses.find(params[:id])
    if @expense.update(expense_params)
      redirect_to @trip, notice: "Expense updated."
    else
      redirect_to @trip, alert: @expense.errors.full_messages.to_sentence
    end
  end

  def destroy
    @expense = @trip.trip_expenses.find(params[:id])
    @expense.destroy!
    redirect_to @trip, notice: "Expense removed."
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:trip_id])
  end

  def expense_params
    params.require(:trip_expense).permit(:trip_member_id, :trip_category_id, :amount, :description, :expense_date, :split_type, split_details: {})
  end
end
