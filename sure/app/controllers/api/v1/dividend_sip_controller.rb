# frozen_string_literal: true

class Api::V1::DividendSipController < Api::V1::BaseController
  before_action :ensure_read_scope

  def suggest
    monthly_investment = params[:monthly_investment].to_f
    target_income = params[:target_income].to_f

    screener = DividendScreener.new(monthly_investment: monthly_investment, target_income: target_income)
    stocks = screener.suggest_stocks
    timeline = screener.calculate_sip_timeline

    render json: {
      suggestions: stocks,
      timeline: timeline,
      monthly_investment: monthly_investment,
      target_income: target_income
    }
  end

  private

  def ensure_read_scope
    authorize_scope!(:read)
  end
end
