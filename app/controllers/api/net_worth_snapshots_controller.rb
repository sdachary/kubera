# frozen_string_literal: true
class Api::NetWorthSnapshotsController < Api::BaseController
  def index
    snapshots = current_user.net_worth_snapshots.recent
    render json: snapshots.map { |s| snapshot_json(s) }
  end

  def show
    if params[:id] == "current"
      snapshot = NetWorthSnapshot.current(current_user)
    else
      snapshot = current_user.net_worth_snapshots.find(params[:id])
    end
    render json: snapshot_json(snapshot)
  end

  private

  def snapshot_json(s)
    { id: s.id, snapshot_date: s.snapshot_date,
      total_assets: s.total_assets&.to_f,
      total_liabilities: s.total_liabilities&.to_f,
      net_worth: s.net_worth&.to_f, breakdown: s.breakdown,
      created_at: s.created_at }
  end
end
