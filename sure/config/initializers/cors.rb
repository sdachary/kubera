# frozen_string_literal: true

# CORS configuration for API access from mobile clients (Flutter) and other external apps.
#
# This enables Cross-Origin Resource Sharing for the /api, /oauth, and /sessions endpoints,
# allowing the Flutter mobile client and other authorized clients to communicate
# with the Rails backend.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Restrict CORS to specific origins for security
    # Configure allowed origins via CORS_ALLOWED_ORIGINS env var (comma-separated)
    # Default: allow localhost for development
    allowed_origins = ENV.fetch("CORS_ALLOWED_ORIGINS", "http://localhost:3000,http://localhost:5173").split(",")

    origins allowed_origins

    # API endpoints for mobile client and third-party integrations
    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[X-Request-Id X-Runtime],
      max_age: 86400

    # OAuth endpoints for authentication flows
    resource "/oauth/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[X-Request-Id X-Runtime],
      max_age: 86400

    # Session endpoints for webview-based authentication
    resource "/sessions/*",
      headers: :any,
      methods: %i[get post delete options head],
      expose: %w[X-Request-Id X-Runtime],
      max_age: 86400
  end
end
