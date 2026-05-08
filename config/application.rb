require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module Kubera
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks generators])
    config.i18n.fallbacks = true

    config.x.ui = ActiveSupport::OrderedOptions.new
    config.x.ui.default_layout = "dashboard"
  end
end
