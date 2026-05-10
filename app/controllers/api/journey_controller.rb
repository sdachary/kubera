# frozen_string_literal: true
class Api::JourneyController < Api::BaseController
  def show
    journey = current_user.journeys.first || current_user.journeys.create!(phase: "negative")
    currency = current_user.currency
    render json: {
      id: journey.id, phase: journey.phase, zero_day_target: journey.zero_day_target,
      monthly_sip_goal: journey.monthly_sip_goal&.to_f,
      wealth_score: journey.wealth_score&.to_f,
      progress_percentage: journey.progress_percentage,
      days_until_zero_day: journey.days_until_zero_day,
      total_debt: current_user.debts.active.sum(:amount).to_f,
      total_investments: current_user.portfolios.sum(&:total_value).to_f,
      notes: journey.notes, created_at: journey.created_at,
      currency_code: journey.currency_code || currency,
      currency_symbol: Currency.symbol_for(journey.currency_code || currency)
    }
  end
end
