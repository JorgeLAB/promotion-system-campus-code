require 'test_helper'

class CouponsApiTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(name: 'IuguBot', email: 'mclovin@iugu.com.br', password: '1234567')
  end

  test 'show coupon' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: Time.zone.tomorrow, user: @user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"
    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)

    assert_equal [coupon.discount_rate, coupon.expiration_date.strftime("%d/%m/%Y")], body[:coupon].values
  end

  test 'show coupon returns success status' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: Time.zone.tomorrow, user: @user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :ok
  end

  test 'coupon not found' do
    get "/api/v1/coupons/0"

    assert_response :not_found
  end

  test 'route is invalid' do
    assert_raises ActionController::RoutingError do
      get "/api/v1/coupon/0"
    end
  end

  test 'disable coupon' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: Time.zone.tomorrow, user: @user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    assert_equal coupon.status, "active"

    post '/api/v1/coupons/NATAL10-0001/disable'

    assert_equal coupon.reload.status, 'disabled'
  end

  test 'disable coupon returns status no_content' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: Time.zone.tomorrow, user: @user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    post '/api/v1/coupons/NATAL10-0001/disable'

    assert_response :no_content
  end

  test 'disable coupon returns error when attempt disable a disabled coupon' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: Time.zone.tomorrow, user: @user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: :disabled)

    post '/api/v1/coupons/NATAL10-0001/disable'

    body = JSON.parse(response.body, symbolize_names: true)

    assert_equal "Não encontrado", body[:errors][:message]
  end

  test 'enable a disabled coupon' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                          expiration_date: Time.zone.tomorrow, user: @user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: :disabled)

    assert_equal coupon.status, "disabled"

    post '/api/v1/coupons/NATAL10-0001/enable'

    assert_equal coupon.reload.status, "active"
  end

  test 'enable coupon returns a status no_content' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: @user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: :disabled)

    post '/api/v1/coupons/NATAL10-0001/enable'

    assert_response :no_content
  end
end
