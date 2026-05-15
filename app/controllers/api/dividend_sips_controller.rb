# frozen_string_literal: true

class Api::DividendSipsController < Api::BaseController
  def index
    sips = DividendSip.joins(portfolio: :user)
                      .where(users: { id: current_user.id })
                      .order(created_at: :desc)
    render_success(sips.map { |s| sip_json(s) })
  end

  def create
    portfolio = current_user.portfolios.find(params[:portfolio_id])
    sip = portfolio.dividend_sips.create!(sip_params)
    render_success(sip_json(sip), status: :created)
  end

  def update
    sip = DividendSip.joins(portfolio: :user)
                     .where(users: { id: current_user.id })
                     .find(params[:id])
    sip.update!(sip_params)
    render_success(sip_json(sip))
  end

  def destroy
    sip = DividendSip.joins(portfolio: :user)
                     .where(users: { id: current_user.id })
                     .find(params[:id])
    sip.destroy!
    render_success({}, message: "Dividend SIP deleted")
  end

  private

  def sip_params
    params.permit(:portfolio_id, :name, :amount, :frequency, :status,
                  :target_income, :next_execution, :currency_code)
  end

  def sip_json(s)
    { id: s.id, portfolio_id: s.portfolio_id, name: s.name,
      amount: s.amount.to_f, frequency: s.frequency, status: s.status,
      target_income: s.target_income&.to_f,
      monthly_contribution: s.monthly_contribution.to_f,
      projected_annual_income: s.projected_annual_income.to_f,
      next_execution: s.next_execution, created_at: s.created_at,
      currency_code: s.currency_code, currency_symbol: Currency.symbol_for(s.currency_code) }
  end
end
