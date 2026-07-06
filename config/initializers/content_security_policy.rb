Rails.application.config.content_security_policy do |policy|
end

Rails.application.config.content_security_policy_nonce_generator = -> request {
  request.env['action_dispatch.content_security_policy_nonce'] ||= SecureRandom.base64(16)
}

Rails.application.config.content_security_policy_nonce_directives = %w[script-src style-src]
