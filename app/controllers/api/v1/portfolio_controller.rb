class Api::V1::PortfolioController < Api::V1::BaseController
  before_action :set_portfolio, only: [:show, :update, :destroy, :rebalance]

  def index
    @portfolios = Portfolio.all
    render json: @portfolios
  end

  def show
    render json: @portfolio
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    if @portfolio.save
      render json: @portfolio, status: :created
    else
      render json: @portfolio.errors, status: :unprocessable_entity
    end
  end

  def update
    if @portfolio.update(portfolio_params)
      render json: @portfolio
    else
      render json: @portfolio.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @portfolio.destroy
    head :no_content
  end

  def rebalance
    assets = @portfolio.holdings.map { |h|
      { symbol: h.security&.ticker || "UNKNOWN", expected_return: 0.08, volatility: 0.15 }
    }
    service = PortfolioService.new(assets, risk_tolerance: @portfolio.risk_tolerance || 0.5)
    render json: {
      portfolio_id: @portfolio.id,
      current_value: @portfolio.total_value,
      allocation: @portfolio.allocation_summary,
      optimization: service.optimize,
      efficient_frontier: service.efficient_frontier
    }
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def portfolio_params
    params.require(:portfolio).permit(:name, :risk_tolerance, :target_allocation, :current_allocation)
  end
end
