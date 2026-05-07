class Api::V1::JourneyController < Api::V1::BaseController
  def show
    tracker = WealthJourneyTracker.new(current_user)
    render json: {
      debt: tracker.debt_progress,
      sip: tracker.sip_progress,
      net_worth: tracker.net_worth_trajectory,
      milestones: tracker.zero_day_milestone,
      score: WealthJourneyTracker.new(current_user).summary[:score]
    }
  end

  def progress
    tracker = WealthJourneyTracker.new(current_user)
    render json: tracker.summary
  end

  def net_worth
    tracker = WealthJourneyTracker.new(current_user)
    months = (params[:months] || 12).to_i.clamp(1, 60)
    render json: tracker.net_worth_trajectory(months: months)
  end

  def projection
    tracker = WealthJourneyTracker.new(current_user)
    render json: tracker.wealth_growth_projection
  end

  def snapshot
    snapshot = NetWorthSnapshot.create_snapshot(current_user)
    render json: snapshot
  end
end
