class OnboardingController < ApplicationController
  layout false
  skip_before_action :check_onboarding, only: [:show, :update]

  def show
    redirect_to(root_path) && return if current_user.onboarded?
  end

  def update
    if current_user.update(onboarding_params.merge(onboarded: true))
      create_consent_records
      redirect_to root_path, notice: "Welcome to Kubera!"
    else
      flash.now[:alert] = "Please fill in all required fields."
      render :show, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    flash.now[:alert] = "Please fill in all required fields."
    render :show, status: :unprocessable_entity
  end

  private

  def create_consent_records
    consents = {
      financial_tracking: params[:consent_financial_tracking],
      trip_data: params[:consent_trip_data],
      email_updates: params[:consent_email_updates],
      marketing: params[:consent_marketing]
    }

    consents.each do |feature, granted|
      next unless granted
      current_user.consent_records.create!(
        feature: feature.to_s,
        granted: true,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        granted_at: Time.current
      )
    end

    if consents.values.any?
      current_user.update!(consent_granted: true, consent_granted_at: Time.current)
    end
  end

  private

  def onboarding_params
    params.require(:user).permit(:first_name, :last_name, :currency, :theme, :timezone)
  end
end
