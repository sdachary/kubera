# frozen_string_literal: true

class Api::V1::DebtPayoffController < Api::V1::BaseController
  before_action :ensure_read_scope

  def index
    @debts = current_resource_owner.family.accounts
                                  .joins(:loan)
                                  .includes(:loan, :accountable)
                                  .where(classification: "liability")

    render :index
  end

  def avalanche
    debts = fetch_debts_with_loans
    calculator = DebtPayoffCalculator.new(debts)
    result = calculator.avalanche_method

    render json: {
      method: "avalanche",
      total_months: result[:total_months],
      payoff_date: result[:payoff_date],
      total_interest: result[:total_interest],
      schedule: serialize_schedule(result[:schedule])
    }
  end

  def snowball
    debts = fetch_debts_with_loans
    calculator = DebtPayoffCalculator.new(debts)
    result = calculator.snowball_method

    render json: {
      method: "snowball",
      total_months: result[:total_months],
      payoff_date: result[:payoff_date],
      total_interest: result[:total_interest],
      schedule: serialize_schedule(result[:schedule])
    }
  end

  def simulate
    debt = find_debt(params[:debt_id])
    return unless debt

    extra_payment = params[:extra_monthly_payment].to_f
    calculator = DebtPayoffCalculator.new([debt])
    result = calculator.payoff_simulation(debt.id, extra_payment)

    render json: {
      debt: serialize_debt(debt),
      original_payoff_months: result[:original_payoff_months],
      new_payoff_months: result[:new_payoff_months],
      months_saved: result[:months_saved],
      new_payoff_date: result[:new_payoff_date]
    }
  end

  def payoff_date
    debts = fetch_debts_with_loans
    calculator = DebtPayoffCalculator.new(debts)
    method = params[:method] || "avalanche"

    result = method == "snowball" ? calculator.snowball_method : calculator.avalanche_method

    render json: {
      debt_free_date: result[:payoff_date],
      total_months: result[:total_months],
      method: method
    }
  end

  def calendar
    month = params[:month].to_i
    year = params[:year].to_i
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    loans = fetch_debts_with_loans

    emis = loans.select { |loan| loan.due_date.present? }.map do |loan|
      due_day = loan.due_date.day rescue 1
      emi_date = Date.new(year, month, [due_day, end_date.day].min)
      next unless emi_date.between?(start_date, end_date)

      {
        loan_id: loan.id,
        account_name: loan.account.name,
        due_date: emi_date,
        amount: loan.emi_amount,
        status: loan.debt_status
      }
    end.compact

    render json: { emis: emis }
  end

  private

  def fetch_debts_with_loans
    current_resource_owner.family.accounts
                          .joins(:loan)
                          .includes(:loan, :accountable)
                          .where(classification: "liability")
                          .map(&:loan)
  end

  def find_debt(debt_id)
    account = current_resource_owner.family.accounts
                                    .joins(:loan)
                                    .includes(:loan)
                                    .find_by(id: debt_id)

    unless account
      render json: { error: "debt_not_found" }, status: :not_found
      return nil
    end

    account.loan
  end

  def serialize_debt(loan)
    account = loan.account
    {
      id: account.id,
      name: account.name,
      balance: account.balance,
      interest_rate: loan.interest_rate,
      emi_amount: loan.emi_amount,
      due_date: loan.due_date,
      debt_status: loan.debt_status,
      months_remaining: loan.months_remaining,
      debt_free_date: loan.debt_free_date,
      progress_percentage: loan.progress_percentage
    }
  end

  def serialize_schedule(schedule)
    schedule.map do |item|
      {
        debt: serialize_debt(item[:debt]),
        months_to_payoff: item[:months_to_payoff],
        interest_paid: item[:interest_paid],
        payoff_date: item[:payoff_date]
      }
    end
  end

  def ensure_read_scope
    authorize_scope!(:read)
  end
end
