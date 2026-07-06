class Api::PortfoliosController < Api::BaseController
  def index
    portfolios = storage.list_portfolios
    render_success(portfolios.map { |p| portfolio_json(p) })
  end

  def show
    portfolio = storage.get_portfolio(id: params[:id])
    render_success(portfolio_json(portfolio))
  end

  def create
    portfolio = storage.create_portfolio(attrs: portfolio_params)
    render_success(portfolio_json(portfolio), status: :created)
  end

  def update
    portfolio = storage.update_portfolio(id: params[:id], attrs: portfolio_params)
    render_success(portfolio_json(portfolio))
  end

  def destroy
    storage.delete_portfolio(id: params[:id])
    head :no_content
  end

  def rebalance
    portfolio = storage.get_portfolio(id: params[:id])
    render_success({ optimal_weights: {} })
  end

  def research
    portfolio = storage.get_portfolio(id: params[:id])
    investments = storage.list_investments(filters: { portfolio_id: params[:id] })
    stocks = investments.select { |i| %w[stock etf].include?(i.investment_type.to_s) }

    if stocks.empty?
      return render_success({ message: "No stock or ETF investments to research" })
    end

    stocks.each do |inv|
      DexterResearchJob.perform_async(params[:id], inv.symbol, inv.respond_to?(:exchange) ? (inv.exchange || "US") : "US")
    end

    render_success({
      message: "Research queued for #{stocks.size} investment(s)",
      queued_count: stocks.size
    })
  end

  private

  def portfolio_params
    source = params[:portfolio].presence || params
    source.permit(:name, :goal, :risk_tolerance, :currency_code, :description,
                  target_allocation: {}, current_allocation: {})
  end

  def portfolio_json(p)
    total_value = p.respond_to?(:total_value) ? p.total_value.to_f : p.amount.to_f
    base_cc = p.currency_code.presence || "INR"

    {
      id: p.id, name: p.name, goal: p.goal, risk_tolerance: p.risk_tolerance&.to_f,
      total_value: total_value, allocation_summary: { sectors: {}, dividend_sips: 0 },
      investments: [], dividend_sips: [], research_analyses: [],
      created_at: p.created_at
    }
  end
end
