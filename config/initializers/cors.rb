Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"

    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[X-Request-Id X-Runtime],
      max_age: 86400
  end
end
