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
    journey = current_user.journeys.first
    total_debt = current_user.debts.active.sum(:amount).to_f
    paid_debt = current_user.debts.where(status: "paid_off").sum(:amount).to_f
    original_debt = total_debt + paid_debt
    debt_reduction_pct = original_debt > 0 ? (paid_debt / original_debt * 100).round(1) : 0

    snapshot = NetWorthSnapshot.current(current_user)
    nw_target = 5000000
    nw_progress_pct = snapshot&.net_worth.to_f > 0 ? [(snapshot.net_worth.to_f / nw_target * 100).round(1), 100.0].min : 0

    render_success({
      debt_progress: { total_debt: total_debt, paid_debt: paid_debt, original_debt: original_debt, reduction_pct: debt_reduction_pct },
      sip_progress: { monthly_goal: journey&.monthly_sip_goal.to_f, progress: journey&.progress_percentage || 0 },
      net_worth_progress: { current: snapshot&.net_worth.to_f, target: nw_target, progress_pct: nw_progress_pct },
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
