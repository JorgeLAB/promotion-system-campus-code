require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(name: 'IuguBot', email: 'mclovin@iugu.com.br', password: '1234567')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: Time.zone.tomorrow, user: user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"
    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.code, body[:code]
  end
end
