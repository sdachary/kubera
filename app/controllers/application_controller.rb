class ApplicationController < ActionController::Base
  helper_method :current_user, :current_session

  before_action :require_login
  before_action :check_onboarding

  rescue_from Exception, with: :handle_exception unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable

  private

  def current_user
    @current_user ||= begin
      token = cookies.signed[:session_token]
      return nil unless token
      session = Session.active.includes(:user).find_by(token: token)
      session&.user
    end
  end

  def current_session
    @current_session ||= begin
      token = cookies.signed[:session_token]
      Session.active.find_by(token: token) if token
    end
  end

  def require_login
    unless current_user
      redirect_to login_path
    end
  end

  def check_onboarding
    if current_user && !current_user.onboarded? && request.path != onboarding_path
      redirect_to onboarding_path
    end
  end

  def authenticate
    render_unauthorized unless current_user
  end

  def render_unauthorized
    respond_to do |format|
      format.html { redirect_to login_path }
      format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
    end
  end

  def handle_exception(exception)
    Rails.logger.error "[Kubera] #{exception.class}: #{exception.message}"
    Rails.logger.error exception.backtrace.first(5).join("\n") if exception.backtrace
    render_error "Something went wrong. Please try again.", :internal_server_error
  end

  def not_found
    render_error "That page doesn't exist.", :not_found
  end

  def unprocessable(exception)
    render_error exception.message, :unprocessable_entity
  end

  def render_error(message, status)
    respond_to do |format|
      format.html { render "pages/error", locals: { message: message }, layout: "application", status: status }
      format.json { render json: { error: message }, status: status }
    end
  end
end
