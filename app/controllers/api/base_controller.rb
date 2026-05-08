# frozen_string_literal: true
class Api::BaseController < ActionController::API
  before_action :authenticate

  private

  def current_user
    @current_user ||= User.first
  end

  def authenticate
    head :unauthorized unless current_user
  end
end
