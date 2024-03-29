require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'eventbrite-client'
require 'cgi'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Happenin
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.assets.precompile += %w( vendor/modernizr facebook_login.js )
  end
end
