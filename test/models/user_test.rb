require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'attribute email cannot be incorrect' do
    user = User.new(email: 'mclovin@gmail.com', password: '1234567', password_confirmation: '1234567')

    refute user.valid?

    assert_includes user.errors[:email], "possui domínio incorreto, utilize @iugu.com.br"
  end
end
