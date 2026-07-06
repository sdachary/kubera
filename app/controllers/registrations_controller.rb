class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :check_onboarding, only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    redirect_to root_path if current_user
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.storage_backend = "local"

    if @user.save
      session_record = @user.sessions.create!(
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
      session_token_cookie(session_record.token)
      redirect_to onboarding_path, notice: "Welcome to Kubera!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end

  def session_token_cookie(token)
    cookies.signed.permanent[:session_token] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }
  end
end
