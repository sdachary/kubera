class OnboardingController < ApplicationController
  skip_before_action :require_onboarding, only: [:show, :update]

  def show
    redirect_to root_path if current_user.onboarded?
  end

  def update
    if current_user.update(onboarding_params.merge(onboarded: true))
      redirect_to root_path, notice: "Welcome to Kubera!"
    else
      flash.now[:alert] = "Please fill in all required fields."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def onboarding_params
    params.require(:user).permit(:first_name, :last_name, :currency, :theme, :timezone)
  end
end
