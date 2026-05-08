# frozen_string_literal: true
class Api::DashboardController < Api::BaseController
  def show
    user = current_user
    total_debt = user.debts.active.sum(:amount).to_f
    total_investments = user.portfolios.sum(&:total_value).to_f
    monthly_expenses = user.recurring_expenses.active.sum(&:monthly_amount)
    net_worth = total_investments - total_debt
    journey = user.journeys.first

    render json: {
      total_debt: total_debt,
      total_investments: total_investments,
      monthly_expenses: monthly_expenses.round(2),
      net_worth: net_worth,
      debt_free_date: journey&.zero_day_target,
      wealth_score: journey&.wealth_score&.to_f,
      portfolio_count: user.portfolios.count,
      debt_count: user.debts.active.count,
      sip_count: DividendSip.joins(portfolio: :user)
                            .where(users: { id: user.id }, status: "active").count,
      unread_notifications: user.notifications.unread.count,
      recent_snapshots: user.net_worth_snapshots.recent.limit(12).map { |s|
        { date: s.snapshot_date, net_worth: s.net_worth.to_f }
      }
    }
  end

  def projection
    user = current_user
    journey = user.journeys.first
    monthly_sip = journey&.monthly_sip_goal&.to_f || 0
    total_debt = user.debts.active.sum(:amount).to_f
    monthly_emi = user.debts.active.sum(:emi_amount).to_f

    projection = (1..60).map do |month|
      remaining_debt = [total_debt - (monthly_emi * month), 0].max
      invested = monthly_sip * month
      { month: month, debt: remaining_debt.round(2),
        investments: invested.round(2),
        net_worth: (invested - remaining_debt).round(2) }
    end

    render json: { projection: projection }
  end
end
