class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :failure]
  skip_before_action :check_onboarding, only: [:new, :create, :failure]
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    redirect_to root_path if current_user
  end

  def create
    if params[:email].present? && params[:password].present?
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        user.update!(onboarded: false) unless user.onboarded?
        session_record = user.sessions.create!(
          ip_address: request.remote_ip,
          user_agent: request.user_agent
        )
        session_token_cookie(session_record.token)
        return redirect_to onboarding_path, notice: 'Signed in successfully'
      end
      return redirect_to login_path, alert: 'Invalid email or password'
    end

    auth = request.env['omniauth.auth']
    return redirect_to root_path, alert: 'Authentication failed' unless auth

    user = case auth.provider
    when 'google_oauth2' then User.from_google(auth)
    when 'github' then User.from_github(auth)
    else return redirect_to login_path, alert: "Unknown provider: #{auth.provider}"
    end

    user.update!(onboarded: false) unless user.onboarded?

    session_record = user.sessions.create!(
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )

    session_token_cookie(session_record.token)
    redirect_to onboarding_path, notice: 'Signed in successfully'
  end

  def destroy
    current_session&.revoke!
    reset_session
    cookies.delete(:session_token)
    redirect_to login_path, notice: 'Signed out successfully'
  end

  def failure
    redirect_to login_path, alert: "Authentication failed: #{params[:message].humanize}"
  end

  def destroy_account
    user = current_user
    return redirect_to login_path, alert: 'Not authenticated' unless user

    session_record = current_session
    session_record&.revoke!
    reset_session
    cookies.delete(:session_token)

    user.sessions.active.update_all(revoked_at: Time.current)
    user.update!(deleted_at: Time.current, onboarded: false)

    redirect_to login_path, notice: 'Your account has been scheduled for deletion. A confirmation email will follow.'
  end

  private

  def session_token_cookie(token)
    cookies.signed.permanent[:session_token] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }
  end
end
