class TenantMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) unless env["HTTP_AUTHORIZATION"]

    token = env["HTTP_AUTHORIZATION"]&.delete_prefix("Bearer ")
    session = Session.active.includes(user: :tenant).find_by(token: token) if token

    if session&.user&.tenant&.db_url.present?
      TenantRecord.establish_connection(session.user.tenant.db_url)
      @app.call(env)
    else
      @app.call(env)
    end
  rescue => e
    Rails.logger.warn "[TenantMiddleware] #{e.class}: #{e.message}"
    @app.call(env)
  end
end
