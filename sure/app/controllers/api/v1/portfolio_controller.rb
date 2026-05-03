class Api::V1::PortfolioController < Api::V1::BaseController
  def rebalance
    statement = InvestmentStatement.new(Current.family)
    holdings = statement.current_holdings
    
    if holdings.empty?
      render json: { error: "No investment holdings found in your portfolio" }, status: :unprocessable_entity
      return
    end

    rebalancer = PortfolioRebalancer.new(holdings)
    result = rebalancer.rebalance

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: result
    end
  end
end
