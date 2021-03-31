require 'application_system_test_case'

class PromotionShowTest < ApplicationSystemTestCase

  include LoginMacros

  test 'should search field in the show promotion' do
    login_user

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                          expiration_date: '22/12/2033')

    visit promotion_path(promotion)

    assert_selector "form input[type=search][placeholder='Pesquisar Coupon']"

    assert_button "Pesquisar"
  end

  test 'search a coupon by exact code' do
    login_user

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033')

    promotion.generated_coupons!

    visit promotion_path(promotion)

    fill_in '', with: 'NATAL10-0001'
    click_on 'Pesquisar'

    within 'div#search_coupon' do
      assert_text "NATAL10-0001 (habilitado)"
      assert_link 'Desabilitar'
    end
  end

  test 'search a coupon by invalid code' do
    login_user

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033')

    promotion.generated_coupons!

    visit promotion_path(promotion)

    fill_in '', with: 'NATAL0001'
    click_on 'Pesquisar'

    within 'div#search_coupon' do
      assert_text 'Código inválido'
    end
  end

  test 'search can not find coupon' do
    login_user

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033')

    promotion.generated_coupons!

    visit promotion_path(promotion)

    fill_in '', with: 'NATAL10-0101'
    click_on 'Pesquisar'

    within 'div#search_coupon' do
      assert_text 'Código não encontrado'
    end
  end


end
