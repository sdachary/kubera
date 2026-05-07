class Api::V1::NetWorthSnapshotsController < Api::V1::BaseController
  def index
    snapshots = NetWorthSnapshot.where(user: current_user).ordered.limit(params[:limit] || 30)
    render json: snapshots
  end

  def show
    snapshot = if params[:id] == "current"
      NetWorthSnapshot.current(current_user)
    else
      NetWorthSnapshot.where(user: current_user).find(params[:id])
    end
    render json: snapshot
  end
end
