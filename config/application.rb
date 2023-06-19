require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module FinalApp
  class Application < Rails::Application
    config.load_defaults 6.0

    # Set the time zone to Indian Standard Time (IST)
    config.time_zone = 'Mumbai'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
