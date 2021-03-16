require 'application_system_test_case'

# AAA

# Arrange
# Act    => visitar o root_path
# Assert => verificar

class HomeTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit root_path

    assert_selector 'h1', text: 'Promotion System'
    assert_selector 'h3', text: 'Boas vindas ao sistema de gestão de promoções'
  end
end