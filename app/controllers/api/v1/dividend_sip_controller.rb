class Api::V1::DividendSipController < Api::V1::BaseController
  before_action :set_dividend_sip, only: [:show, :update, :destroy, :suggest]

  def index
    @dividend_sips = DividendSip.all
    render json: @dividend_sips
  end

  def show
    render json: @dividend_sip
  end

  def create
    @dividend_sip = DividendSip.new(dividend_sip_params)
    if @dividend_sip.save
      render json: @dividend_sip, status: :created
    else
      render json: @dividend_sip.errors, status: :unprocessable_entity
    end
  end

  def update
    if @dividend_sip.update(dividend_sip_params)
      render json: @dividend_sip
    else
      render json: @dividend_sip.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @dividend_sip.destroy
    head :no_content
  end

  def suggest
    service = DividendSipService.new(
      dividend_sip: @dividend_sip,
      monthly_investment: params[:monthly_investment].to_f,
      target_income: params[:target_income].to_f
    )
    render json: service.calculate_sip_timeline
  end

  private

  def set_dividend_sip
    @dividend_sip = DividendSip.find(params[:id])
  end

  def dividend_sip_params
    params.require(:dividend_sip).permit(:name, :portfolio_id, :monthly_investment, :target_income, :dividend_yield)
  end
end
