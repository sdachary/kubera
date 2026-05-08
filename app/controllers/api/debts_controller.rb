# frozen_string_literal: true
class Api::DebtsController < Api::BaseController
  def index
    debts = current_user.debts.order(created_at: :desc)
    render json: debts.map { |d| debt_json(d) }
  end

  def create
    debt = current_user.debts.create!(debt_params)
    render json: debt_json(debt), status: :created
  end

  def update
    debt = current_user.debts.find(params[:id])
    debt.update!(debt_params)
    render json: debt_json(debt)
  end

  def destroy
    current_user.debts.find(params[:id]).destroy!
    head :no_content
  end

  private

  def debt_params
    params.permit(:name, :category, :amount, :interest_rate, :emi_amount,
                  :due_date, :status, :started_at, :paid_amount, :notes)
  end

  def debt_json(d)
    { id: d.id, name: d.name, category: d.category, amount: d.amount.to_f,
      interest_rate: d.interest_rate&.to_f, emi_amount: d.emi_amount&.to_f,
      due_date: d.due_date, status: d.status, paid_amount: d.paid_amount.to_f,
      remaining: d.remaining_amount.to_f, progress: d.progress_percentage,
      debt_free_date: d.debt_free_date, months_remaining: d.months_remaining,
      started_at: d.started_at, notes: d.notes, created_at: d.created_at }
  end
end
