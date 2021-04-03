require 'test_helper'

class CouponFlowTest < ActionDispatch::IntegrationTest
  test 'can not disable a coupon without login' do
    user = User.create!(email: 'mclovin@iugu.com.br', password: '1234567')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: user)

    coupon = Coupon.create!(code:"NATAL10-0001", promotion: promotion)

    post disable_coupon_path(coupon)

    assert_redirected_to new_user_session_path
  end

  test 'can not enable a coupon without login' do
    user = User.create!(email: 'mclovin@iugu.com.br', password: '1234567')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                          expiration_date: '22/12/2033', user: user)

    coupon = Coupon.create!(code:"NATAL10-0001", promotion: promotion)
    coupon.disabled!

    post enable_coupon_path(coupon)

    assert_redirected_to new_user_session_path
  end
end
