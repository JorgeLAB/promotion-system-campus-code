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

  test 'cannot edit a promotion without login' do
    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 100,
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10,
                              expiration_date: '22/12/2033')

    patch promotion_path(promotion, params: {
      promotion: { name: 'Natal', coupon_quantity: 100,
             description: 'Promoção de Carnaval',
             code: 'CARNAVAL'
        }
      }
    )

    assert_redirected_to new_user_session_path
  end

  test 'cannot edit a promotion with coupons' do
    login_user

    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 100,
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10,
                              expiration_date: '22/12/2033')

    promotion.generated_coupons!

    patch promotion_path(promotion, params: {
      promotion: { coupon_quantity: 10,
             description: 'Promoção de Carnaval',
             code: 'CARNAVAL'
        }
      }
    )

    assert_redirected_to promotions_path
  end

  test 'cannot destroy a promotion without login' do
    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 10,
                          description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10,
                          expiration_date: '22/12/2033')

    delete promotion_path(promotion)

    assert_redirected_to new_user_session_path
  end

  test 'when destroying a promotion, all your coupons are removed' do
    login_user

    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 10,
                      description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10,
                      expiration_date: '22/12/2033')

    promotion.generated_coupons!

    assert_difference "Coupon.count", -promotion.coupon_quantity do
      delete promotion_path(promotion)
    end
  end
end
