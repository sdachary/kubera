# frozen_string_literal: true

class Api::BaseController < ActionController::API
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  protected

  def render_success(data = {}, message: nil, status: :ok)
    render json: data, status: status
  end

  def render_error(message, status: :unprocessable_entity, errors: nil)
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: status
  end

  def render_unauthorized(message = "Unauthorized")
    render_error(message, status: :unauthorized)
  end

  def render_not_found(exception)
    render_error(exception.message, status: :not_found)
  end

  def render_unprocessable_entity(exception)
    render_error("Validation failed", status: :unprocessable_entity, errors: exception.record.errors.full_messages)
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
    render_unauthorized unless current_user
  end
end
