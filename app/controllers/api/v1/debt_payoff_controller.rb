class Api::V1::DebtPayoffController < Api::V1::BaseController
  before_action :set_debt, only: [:show, :update, :destroy, :simulate]

  def index
    @debts = Debt.all
    render json: @debts
  end

  def show
    render json: @debt
  end

  def create
    @debt = Debt.new(debt_params)
    if @debt.save
      render json: @debt, status: :created
    else
      render json: @debt.errors, status: :unprocessable_entity
    end
  end

  def update
    if @debt.update(debt_params)
      render json: @debt
    else
      render json: @debt.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @debt.destroy
    head :no_content
  end

  def simulate
    extra_payment = params[:extra_monthly_payment].to_f
    service = DebtPayoffService.new([@debt], extra_payment)
    result = service.avalanche_method
    render json: result
  end

  private

  def set_debt
    @debt = Debt.find(params[:id])
  end

  def debt_params
    params.require(:debt).permit(:name, :balance, :interest_rate, :min_payment, :emi_amount, :due_date)
  end
end
