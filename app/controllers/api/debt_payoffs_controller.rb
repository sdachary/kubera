# frozen_string_literal: true
class Api::DebtPayoffsController < Api::BaseController
  def index
    payoffs = current_user.debt_payoffs.order(created_at: :desc)
    render json: payoffs.map { |p| payoff_json(p) }
  end

  def show
    payoff = current_user.debt_payoffs.find(params[:id])
    render json: payoff_json(payoff)
  end

  private

  def payoff_json(p)
    { id: p.id, name: p.name, strategy: p.strategy, extra_payment: p.extra_payment&.to_f,
      months_saved: p.months_saved, debt_free_date: p.debt_free_date,
      total_interest_paid: p.total_interest_paid&.to_f,
      total_interest_saved: p.total_interest_saved&.to_f,
      total_debt: p.total_debt.to_f, debt_count: p.debts.count,
      debts: p.debts.map { |d| { id: d.id, name: d.name, amount: d.amount.to_f, currency_code: d.currency_code } },
      schedule: p.schedule, created_at: p.created_at,
      currency_code: p.currency_code, currency_symbol: Currency.symbol_for(p.currency_code) }
  end
end
