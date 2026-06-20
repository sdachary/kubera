class TripSettlementsController < ApplicationController
  before_action :set_trip

  def index
    @settlements = @trip.trip_settlements.includes(:from_member, :to_member).order(created_at: :desc)
    @balances = @trip.balances
    render json: {
      settlements: @settlements.map { |s|
        { id: s.id, from: s.from_member.name, to: s.to_member.name,
          amount: s.amount.to_f, settled_at: s.settled_at, notes: s.notes }
      },
      balances: @balances
    }
  end

  def create
    from_id = params[:trip_settlement][:from_trip_member_id]
    to_id = params[:trip_settlement][:to_trip_member_id]
    amount = params[:trip_settlement][:amount].to_f

    if from_id == to_id
      redirect_to @trip, alert: "Cannot settle with yourself."
      return
    end

    if amount <= 0
      redirect_to @trip, alert: "Amount must be positive."
      return
    end

    balances = @trip.balances
    from_balance = balances[from_id.to_i].to_f
    to_balance = balances[to_id.to_i].to_f

    if from_balance >= 0
      redirect_to @trip, alert: "#{@trip.trip_members.find(from_id).name} doesn't owe anything."
      return
    end

    if to_balance <= 0
      redirect_to @trip, alert: "#{@trip.trip_members.find(to_id).name} isn't owed anything."
      return
    end

    max_settle = [from_balance.abs, to_balance].min
    if amount > max_settle
      amount = max_settle
    end

    @settlement = @trip.trip_settlements.create!(
      from_trip_member_id: from_id,
      to_trip_member_id: to_id,
      amount: amount,
      settled_at: Time.current,
      notes: params[:trip_settlement][:notes]
    )

    redirect_to @trip, notice: "Settlement of #{format('%.2f', amount)} recorded."
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:trip_id])
  end
end
