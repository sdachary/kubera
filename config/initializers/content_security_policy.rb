Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, "https://fonts.gstatic.com"
  policy.img_src     :self, :data, :blob
  policy.object_src  :none
  policy.script_src  :self
  policy.style_src   :self, :https, "https://fonts.googleapis.com"
  policy.connect_src :self
  policy.frame_ancestors :none
  policy.form_action :self
  policy.base_uri    :self
end

Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }
Rails.application.config.content_security_policy_nonce_directives = %w[script-src style-src]
