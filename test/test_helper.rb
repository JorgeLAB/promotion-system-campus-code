ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'coveralls'
Coveralls.wear!

SimpleCov.start 'rails' do
  add_filter 'jobs'
  add_filter 'mailers'
  add_filter 'channels'
end

require_relative "../config/environment"
require "rails/test_help"

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }

class ActiveSupport::TestCase

  include Warden::Test::Helpers
  include ActionView::Helpers::NumberHelper
  include IntegrationApi

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end

  parallelize_teardown do
    SimpleCov.result
  end

  Minitest.load_plugins
  Minitest::PrideIO.pride!
end
