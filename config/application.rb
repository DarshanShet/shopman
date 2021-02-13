require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shopman
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = "Mumbai"
    config.active_record.default_timezone = :local

    RenderAsync.configure do |config|
      config.turbolinks = true # Enable this option if you are using Turbolinks 5+
    end
  end
end
