class Api::HouseholdsController < Api::BaseController
  def index
    households = current_user.households
    render json: households.map { |h| household_summary(h) }
  end

  def show
    household = find_household
    service = HouseholdDashboardService.new(household)
    render json: service.overview
  end

  def create
    household = Household.create!(name: params[:name], currency: params[:currency] || "INR")
    household.add_member(current_user, role: "owner")
    render json: household_summary(household), status: :created
  end

  def update
    household = find_household
    household.update!(params.permit(:name, :currency, :description))
    render json: household_summary(household)
  end

  def destroy
    household = find_household
    household.destroy!
    head :no_content
  end

  def members
    household = find_household
    render json: household.household_memberships.accepted.map { |m|
      { id: m.user_id, name: [m.user.first_name, m.user.last_name].compact.join(" "),
        email: m.user.email, role: m.role, joined_at: m.joined_at }
    }
  end

  def invite
    household = find_household
    user = User.find_by(email: params[:email])
    return render json: { error: "User not found" }, status: :not_found unless user

    household.add_member(user, role: params[:role] || "member")
    render json: { message: "Invited #{user.email} to #{household.name}" }
  end

  def leave
    membership = current_user.household_memberships.find_by(household_id: params[:id])
    return render json: { error: "Not a member" }, status: :not_found unless membership

    membership.destroy!
    head :no_content
  end

  def dashboard
    household = find_household
    service = HouseholdDashboardService.new(household)
    render json: service.overview
  end

  private

  def find_household
    current_user.households.find(params[:id])
  end

  def household_summary(h)
    { id: h.id, name: h.name, currency: h.currency,
      description: h.description, member_count: h.members.count,
      created_at: h.created_at }
  end
end
