class ApplicationController < ActionController::Base
  helper_method :current_user

  rescue_from Exception, with: :handle_exception unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable

  private

  def current_user
    @current_user ||= begin
      user = User.first
      if user.nil? && run_first_boot_setup!
        user = User.first
      end
      user
    end
  end

  def run_first_boot_setup!
    Rails.logger.info "[Kubera] First boot detected. Running setup..."
    begin
      ActiveRecord::Migration.check_pending!
    rescue ActiveRecord::PendingMigrationError
      Rails.logger.info "[Kubera] Running pending migrations..."
      ActiveRecord::Migration.migrate
    end

    unless User.exists?
      user = User.create!(
        email: "me@kubera.local",
        password: SecureRandom.hex(32),
        onboarded: true,
        theme: "dark",
        currency: "INR"
      )
      user.journeys.create!(phase: "negative")
      Rails.logger.info "[Kubera] Default user created."
    end
    true
  rescue => e
    Rails.logger.error "[Kubera] First boot setup failed: #{e.message}"
    false
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
