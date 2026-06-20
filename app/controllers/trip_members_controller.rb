class TripMembersController < ApplicationController
  before_action :set_trip

  def create
    @member = @trip.trip_members.new(member_params)
    @member.added_at = Time.current

    if @member.save
      redirect_to @trip, notice: "#{@member.name} added to trip."
    else
      redirect_to @trip, alert: @member.errors.full_messages.to_sentence
    end
  end

  def destroy
    @member = @trip.trip_members.find(params[:id])
    @member.destroy!
    redirect_to @trip, notice: "#{@member.name} removed from trip."
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:trip_id])
  end

  def member_params
    params.require(:trip_member).permit(:name, :email)
  end
end
