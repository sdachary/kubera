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
    service = PortfolioService.new(@portfolio)
    render json: service.rebalance
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def portfolio_params
    params.require(:portfolio).permit(:name, :risk_tolerance, :target_allocation, :current_allocation)
  end
end
