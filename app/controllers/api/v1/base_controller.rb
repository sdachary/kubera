class Api::V1::BaseController < ApplicationController
  respond_to :json

  # Base controller for native Kubera API
  
  def current_user
    # In a local-only app, we might just use the first user or a guest
    @current_user ||= User.first
  end

  private

  def authorize_scope!(scope)
    # Stub for native app
  end
end
