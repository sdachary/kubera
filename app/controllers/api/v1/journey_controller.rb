class Api::V1::JourneyController < Api::V1::BaseController
  def show
    tracker = WealthJourneyTracker.new(current_user)
    render json: {
      debt: tracker.debt_progress,
      sip: tracker.sip_progress,
      net_worth: tracker.net_worth_trajectory,
      milestones: tracker.zero_day_milestone
    }
  end

  def progress
    tracker = WealthJourneyTracker.new(current_user)
    render json: {
      debt_progress: tracker.debt_progress,
      sip_progress: tracker.sip_progress,
      net_worth_trajectory: tracker.net_worth_trajectory,
      milestones: tracker.zero_day_milestone
    }
  end

  def net_worth
    tracker = WealthJourneyTracker.new(current_user)
    render json: tracker.net_worth_trajectory
  end
end
