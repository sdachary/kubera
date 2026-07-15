class Api::AuthController < ActionController::API
  before_action :authenticate, only: [:me, :update_profile, :logout]

  def register
    user = User.new(registration_params)
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if user.save
      session = user.sessions.create!(
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
      render json: {
        token: session.token,
        user: user_response(user)
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def forgot_password
    user = User.find_by(email: params[:email])
    if user
      token = user.generate_password_reset_token
      UserMailer.password_reset(user, token).deliver_later
    end
    render json: { message: "If the email exists, a reset link has been sent." }
  end

  def reset_password
    user = User.find_by_password_reset_token(params[:token])
    return render json: { error: "Invalid or expired reset token" }, status: :unprocessable_entity unless user
    return render json: { error: "Reset token has expired" }, status: :unprocessable_entity if user.password_reset_expired?

    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if user.save
      user.sessions.where.not(id: user.sessions.select(:id).last).destroy_all
      user.update!(password_reset_token: nil, password_reset_sent_at: nil)
      render json: { message: "Password reset successfully." }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session = user.sessions.create!(
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
      render json: {
        token: session.token,
        user: user_response(user)
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def me
    render json: { user: user_response(current_user) }
  end

  def update_profile
    if current_user.update(profile_params)
      render json: { user: user_response(current_user) }
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def logout
    current_session&.revoke!
    head :no_content
  end

  private

  def current_user
    @current_user ||= begin
      token = request.headers['Authorization']&.delete_prefix('Bearer ')
      return nil unless token
      session = Session.active.includes(:user).find_by(token: token)
      session&.user
    end
  end

  def current_session
    @current_session ||= begin
      token = request.headers['Authorization']&.delete_prefix('Bearer ')
      Session.active.find_by(token: token) if token
    end
  end

  def authenticate
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      currency: user.currency,
      onboarded: user.onboarded?
    }
  end

  def registration_params
    params.permit(:email, :first_name, :last_name)
  end

  def profile_params
    params.permit(:first_name, :last_name, :currency) # ponytail: model-level validations only, no custom validation needed yet
  end
end
