class Api::InvestmentsController < Api::BaseController
  def index
    investments = Investment.joins(portfolio: :user)
                           .where(users: { id: current_user.id })
                           .order(created_at: :desc)
    render json: investments.map { |i| investment_json(i) }
  end

  def create
    portfolio = current_user.portfolios.find(params[:portfolio_id])
    investment = portfolio.investments.create!(investment_params)
    render json: investment_json(investment), status: :created
  end

  def update
    investment = Investment.joins(portfolio: :user)
                           .where(users: { id: current_user.id })
                           .find(params[:id])
    investment.update!(investment_params)
    render json: investment_json(investment)
  end

  def destroy
    investment = Investment.joins(portfolio: :user)
                           .where(users: { id: current_user.id })
                           .find(params[:id])
    investment.destroy!
    head :no_content
  end

  private

  def investment_params
    params.permit(:portfolio_id, :symbol, :name, :investment_type, :shares,
                  :buy_price, :current_price, :dividend_yield, :sector, :notes)
  end

  def investment_json(i)
    { id: i.id, portfolio_id: i.portfolio_id, symbol: i.symbol, name: i.name,
      shares: i.shares&.to_f, buy_price: i.buy_price&.to_f,
      current_price: i.current_price&.to_f, current_value: i.current_value.to_f,
      gain_loss: i.gain_loss.to_f, gain_loss_pct: i.gain_loss_percentage,
      dividend_yield: i.dividend_yield&.to_f, sector: i.sector,
      investment_type: i.investment_type, notes: i.notes, created_at: i.created_at }
  end
end
