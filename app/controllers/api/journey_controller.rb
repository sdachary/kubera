# frozen_string_literal: true

class Api::JourneyController < Api::BaseController
  def show
    journey = current_user.journeys.first || current_user.journeys.create!(phase: "negative")
    total_debt = current_user.debts.active.sum(:amount).to_f
    total_emi = current_user.debts.active.sum(:emi_amount).to_f
    total_investments = current_user.portfolios.sum(&:total_value).to_f
    snapshot = NetWorthSnapshot.current(current_user)
    render_success({
      debt: { total_debt: total_debt, total_emi: total_emi },
      sip: { monthly_goal: journey.monthly_sip_goal.to_f, progress: journey.progress_percentage },
      net_worth: { net_worth: snapshot.net_worth.to_f, assets: total_investments, liabilities: total_debt },
      milestones: []
    })
  end

  def progress
    render_success({
      debt_progress: { total_debt: current_user.debts.active.sum(:amount).to_f },
      sip_progress: { monthly_goal: 0, progress: 0 },
      net_worth_trajectory: [],
      milestones: []
    })
  end

  def net_worth
    snapshot = NetWorthSnapshot.current(current_user)
    render_success({
      net_worth: snapshot.net_worth.to_f,
      trajectory: []
    })
  end
end
