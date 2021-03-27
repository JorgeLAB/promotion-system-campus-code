require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest

  include LoginMacros

  test 'can create a promotion' do
    login_user

    post '/promotions', params: {
      promotion: { name: 'Natal', coupon_quantity: 100,
                   description: 'Promoção de Natal',
                   code: 'NATAL10', discount_rate: 10,
                   expiration_date: '22/12/2033'
                 }
    }

    assert_redirected_to promotion_path(Promotion.last)
    assert_response :found
    # follow_redirect!
    # assert_select "dl"
  end

  test 'cannot create a promotion without login' do

    post '/promotions', params: {
      promotion: { name: 'Natal', coupon_quantity: 100,
                   description: 'Promoção de Natal',
                   code: 'NATAL10', discount_rate: 10,
                   expiration_date: '22/12/2033'
                 }
    }

    assert_redirected_to new_user_session_path
  end

  test 'cannot generate coupons without login' do
    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 100,
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  expiration_date: '22/12/2033')

    post generate_coupon_promotion_path(promotion)

    assert_redirected_to new_user_session_path
  end
end
