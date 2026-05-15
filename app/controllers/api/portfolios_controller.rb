# frozen_string_literal: true

class Api::PortfoliosController < Api::BaseController
  def index
    portfolios = current_user.portfolios.order(created_at: :desc)
    render_success(portfolios.map { |p| portfolio_json(p) })
  end

  def show
    portfolio = current_user.portfolios.find(params[:id])
    render_success(portfolio_json(portfolio))
  end

  private

  def portfolio_json(p)
    { id: p.id, name: p.name, goal: p.goal, risk_tolerance: p.risk_tolerance&.to_f,
      total_value: p.total_value.to_f,
      allocation_summary: p.allocation_summary,
      investments: p.investments.map { |i| investment_json(i) },
      dividend_sips: p.dividend_sips.map { |s| sip_json(s) },
      created_at: p.created_at }
  end

  def investment_json(i)
    { id: i.id, symbol: i.symbol, name: i.name, shares: i.shares&.to_f,
      buy_price: i.buy_price&.to_f, current_price: i.current_price&.to_f,
      current_value: i.current_value.to_f, gain_loss: i.gain_loss.to_f,
      gain_loss_pct: i.gain_loss_percentage, dividend_yield: i.dividend_yield&.to_f,
      sector: i.sector, investment_type: i.investment_type }
  end

  def sip_json(s)
    { id: s.id, name: s.name, amount: s.amount.to_f, frequency: s.frequency,
      status: s.status, target_income: s.target_income&.to_f,
      monthly_contribution: s.monthly_contribution.to_f,
      projected_annual_income: s.projected_annual_income.to_f,
      next_execution: s.next_execution }
  end
end
