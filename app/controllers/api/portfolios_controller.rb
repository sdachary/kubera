class Api::PortfoliosController < Api::BaseController
  def index
    portfolios = current_user.portfolios.order(created_at: :desc)
    render_success(portfolios.map { |p| portfolio_json(p) })
  end

  def show
    portfolio = current_user.portfolios.find(params[:id])
    render_success(portfolio_json(portfolio))
  end

  def create
    portfolio = current_user.portfolios.create!(portfolio_params)
    render_success(portfolio_json(portfolio), status: :created)
  end

  def update
    portfolio = current_user.portfolios.find(params[:id])
    portfolio.update!(portfolio_params)
    render_success(portfolio_json(portfolio))
  end

  def destroy
    current_user.portfolios.find(params[:id]).destroy!
    head :no_content
  end

  def rebalance
    portfolio = current_user.portfolios.find(params[:id])
    render_success({ optimal_weights: {} })
  end

  def research
    portfolio = current_user.portfolios.find(params[:id])
    investments = portfolio.investments.where(investment_type: %w[stock etf])

    if investments.empty?
      return render_success({ message: "No stock or ETF investments to research" })
    end

    investments.each do |inv|
      DexterResearchJob.perform_async(portfolio.id, inv.symbol, inv.exchange || "US")
    end

    render_success({
      message: "Research queued for #{investments.size} investment(s)",
      queued_count: investments.size
    })
  end

  private

  def portfolio_params
    source = params[:portfolio].presence || params
    source.permit(:name, :goal, :risk_tolerance, :currency_code, :description,
                  target_allocation: {}, current_allocation: {})
  end

  def portfolio_json(p)
    research = p.research_analyses.includes(:portfolio).successful.recent.limit(5).map do |ra|
      analysis = ra.analysis
      {
        id: ra.id,
        ticker: ra.ticker,
        exchange: ra.exchange,
        company_name: ra.company_name,
        sector: ra.sector,
        summary: ra.summary,
        pe_category: analysis&.pe_category,
        healthy: analysis&.healthy?,
        ratios: ra.ratios_data,
        researched_at: ra.researched_at
      }
    end

    {
      id: p.id, name: p.name, goal: p.goal, risk_tolerance: p.risk_tolerance&.to_f,
      total_value: p.total_value.to_f,
      allocation_summary: p.allocation_summary,
      investments: p.investments.map { |i| investment_json(i) },
      dividend_sips: p.dividend_sips.map { |s| sip_json(s) },
      research_analyses: research,
      created_at: p.created_at
    }
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

  def sip_json(s)
    { id: s.id, name: s.name, amount: s.amount.to_f, frequency: s.frequency,
      status: s.status, target_income: s.target_income&.to_f,
      monthly_contribution: s.monthly_contribution.to_f,
      projected_annual_income: s.projected_annual_income.to_f,
      next_execution: s.next_execution }
  end
end
