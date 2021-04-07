require 'application_system_test_case'

class UnauthrnticatedPromotionsTest < ApplicationSystemTestCase
  def setup
    @user = User.create!(name: 'Jorge', email: 'mclovin@iugu.com.br', password: '1234567')
  end

  test 'does not show index promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'does not show promotion details without login' do

    promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                  description: 'Promoção de Cyber Monday',
                  code: 'CYBER15', discount_rate: 15,
                  expiration_date: Time.zone.tomorrow, user: @user)

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end


  test 'can not search a coupon without login' do

    promotion_natal = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                        code: 'NATAL10', discount_rate: 10,
                                        coupon_quantity: 100, expiration_date: Time.zone.tomorrow, user: @user)

    promotion_natal.generated_coupons!

    visit search_coupon_promotion_path(promotion_natal, query: 'NATAL10-0099')

    assert_current_path new_user_session_path
  end

  test 'can not search a promotion without login' do

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: @user)

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: @user)

    visit search_promotions_path(query: 'Natal')

    assert_current_path new_user_session_path
  end
end
