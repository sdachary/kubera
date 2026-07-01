# frozen_string_literal: true

class Api::InvestmentsController < Api::BaseController
  def index
    investments = current_user.portfolios
      .includes(:investments).flat_map(&:investments)
    render_success(investments.map { |i| investment_json(i) })
  end

  def create
    portfolio = current_user.portfolios.find(params[:portfolio_id])
    investment = portfolio.investments.create!(investment_params)
    DexterResearchJob.perform_async(portfolio.id, investment.symbol, investment.exchange || "US") if %w[stock etf].include?(investment.investment_type)
    render_success(investment_json(investment), status: :created)
  end

  def update
    # Note: Using find_by for safety with manual selection from flat_map
    investment = Investment.joins(portfolio: :user).where(users: { id: current_user.id }).find(params[:id])
    investment.update!(investment_params)
    render_success(investment_json(investment))
  end

  def destroy
    investment = Investment.joins(portfolio: :user).where(users: { id: current_user.id }).find(params[:id])
    investment.destroy!
    render_success({}, message: "Investment deleted")
  end

  private

  def investment_params
    params.permit(:symbol, :name, :shares, :buy_price, :investment_type, :sector, :notes,
                  :currency_code, :exchange)
  end

  def investment_json(i)
    { id: i.id, symbol: i.symbol, name: i.name, shares: i.shares&.to_f,
      buy_price: i.buy_price&.to_f, current_price: i.current_price&.to_f,
      current_value: i.current_value.to_f, gain_loss: i.gain_loss.to_f,
      gain_loss_pct: i.gain_loss_percentage, dividend_yield: i.dividend_yield&.to_f,
      sector: i.sector, investment_type: i.investment_type,
      currency_code: i.currency_code, currency_symbol: Currency.symbol_for(i.currency_code),
      exchange: i.exchange }
  end
end
