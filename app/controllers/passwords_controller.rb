class PasswordsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :edit, :update]
  skip_before_action :check_onboarding, only: [:new, :create, :edit, :update]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)
    if user
      token = user.generate_password_reset_token
      UserMailer.password_reset(user, token).deliver_later
    end
    redirect_to login_path, notice: "If an account with that email exists, you'll receive a password reset link shortly."
  end

  def edit
    @user = User.find_by_password_reset_token(params[:token])
    return redirect_to(login_path, alert: "Invalid or expired password reset link.") unless @user && !@user.password_reset_expired?
  end

  def update
    @user = User.find_by_password_reset_token(params[:token])
    return redirect_to login_path, alert: "Invalid or expired password reset link." unless @user && !@user.password_reset_expired?

    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation], password_reset_token: nil, password_reset_sent_at: nil)
      redirect_to login_path, notice: "Password has been reset successfully. Please sign in."
    else
      render :edit, status: :unprocessable_entity
    end
  end
end
