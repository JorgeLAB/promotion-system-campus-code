require "test_helper"


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Warden::Test::Helpers
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  #Capybara.server = :puma, { Silent: true}

  # def take_failed_screenshot
  # 	false
  # end
end
