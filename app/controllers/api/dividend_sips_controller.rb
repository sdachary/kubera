# frozen_string_literal: true
class Api::DividendSipsController < Api::BaseController
  def index
    sips = DividendSip.joins(portfolio: :user)
                      .where(users: { id: current_user.id })
                      .order(created_at: :desc)
    render json: sips.map { |s| sip_json(s) }
  end

  def create
    portfolio = current_user.portfolios.find(params[:portfolio_id])
    sip = portfolio.dividend_sips.create!(sip_params)
    render json: sip_json(sip), status: :created
  end

  def update
    sip = DividendSip.joins(portfolio: :user)
                     .where(users: { id: current_user.id })
                     .find(params[:id])
    sip.update!(sip_params)
    render json: sip_json(sip)
  end

  def destroy
    sip = DividendSip.joins(portfolio: :user)
                     .where(users: { id: current_user.id })
                     .find(params[:id])
    sip.destroy!
    head :no_content
  end

  private

  def sip_params
    params.permit(:portfolio_id, :name, :amount, :frequency, :status,
                  :target_income, :next_execution)
  end

  def sip_json(s)
    { id: s.id, portfolio_id: s.portfolio_id, name: s.name,
      amount: s.amount.to_f, frequency: s.frequency, status: s.status,
      target_income: s.target_income&.to_f,
      monthly_contribution: s.monthly_contribution.to_f,
      projected_annual_income: s.projected_annual_income.to_f,
      next_execution: s.next_execution, created_at: s.created_at }
  end
end
