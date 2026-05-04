class Api::V1::JourneyController < Api::V1::BaseController
  before_action :ensure_read_scope

  def dashboard
    tracker = WealthJourneyTracker.new(current_resource_owner)
    render json: {
      debt: tracker.debt_progress,
      sip: tracker.sip_progress,
      net_worth: tracker.net_worth_trajectory,
      zero_day: tracker.zero_day_milestone
    }
  end

  def net_worth_chart
    tracker = WealthJourneyTracker.new(current_resource_owner)
    render json: tracker.net_worth_trajectory[:trajectory]
  end

  private

  def ensure_read_scope
    authorize_scope!(:read)
  end
end
