require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase

  include LoginMacros

  test 'disable a coupon' do
    login_user

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    coupon = Coupon.create!(code:"NATAL10-0001", promotion: promotion)

    visit promotion_path(promotion)
    click_on 'Desabilitar'

    assert_text 'Coupom desabilitado com sucesso!'
    assert_text "#{coupon.code} (desabilitado)"
    assert_no_link 'Desabilitar'
    assert_link 'Habilitar'
  end

  test 'enable a coupon' do
    login_user

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    coupon = Coupon.create!(code:"NATAL10-0001", promotion: promotion)
    coupon.disabled!

    visit promotion_path(promotion)

    click_on 'Habilitar'

    assert_text 'Coupom habilitado com sucesso!'
    assert_text "#{coupon.code} (habilitado)"
    assert_link 'Desabilitar'
  end
end
