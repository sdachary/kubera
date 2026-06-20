class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :settle, :archive]

  def index
    @trips = current_user.trips.order(created_at: :desc)
  end

  def show
    @trip_member = @trip.trip_members.new
    @trip_expense = @trip.trip_expenses.new
    @expenses = @trip.trip_expenses.includes(:trip_member, :trip_category).order(created_at: :desc)
    @balances = @trip.balances
    @budget_vs_actual = @trip.budget_vs_actual
    @settlements = @trip.trip_settlements.includes(:from_member, :to_member).order(created_at: :desc)
  end

  def new
    @trip = current_user.trips.new
  end

  def edit
  end

  def create
    @trip = current_user.trips.new(trip_params)
    if @trip.save
      redirect_to @trip, notice: "Trip created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: "Trip updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip.destroy!
    redirect_to trips_path, notice: "Trip deleted."
  end

  def settle
    @trip.update!(status: "settled")
    redirect_to @trip, notice: "Trip marked as settled."
  end

  def archive
    @trip.update!(status: "archived")
    redirect_to trips_path, notice: "Trip archived."
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name, :destination, :start_date, :end_date, :currency, :group_type, :total_budget, :notes)
  end
end
