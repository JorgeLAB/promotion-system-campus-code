require 'application_system_test_case'

class PromotionShowTest < ApplicationSystemTestCase

  include LoginMacros

  def setup
    @user = login_user
  end

  test 'should search field in the show promotion' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                          expiration_date: Time.zone.tomorrow, user: @user)

    promotion.generated_coupons!

    visit promotion_path(promotion)

    assert_selector "form input[type=search][placeholder='Pesquisar Coupon']"

    assert_button "Pesquisar"
  end

  test 'hidden research field without coupons' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: @user)


    visit promotion_path(promotion)

    assert_no_selector "div#search_coupon"
  end

  test 'search a coupon by exact code' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: Time.zone.tomorrow, user: @user)

    promotion.generated_coupons!

    visit promotion_path(promotion)


    within 'form#search_coupon' do
      fill_in 'Buscar', with: 'NATAL10-0001'
    end

    click_on 'Pesquisar'

    within 'div#search_coupon' do
      assert_text "NATAL10-0001 (habilitado)"
      assert_link 'Desabilitar'
    end
  end

  test 'search a coupon by invalid code' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: Time.zone.tomorrow, user: @user)

    promotion.generated_coupons!

    visit promotion_path(promotion)

    fill_in '', with: 'NATAL0001'
    click_on 'Pesquisar'

    within 'div#search_coupon' do
      assert_text 'Código inválido'
    end
  end

  test 'search can not find coupon' do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: Time.zone.tomorrow, user: @user)

    promotion.generated_coupons!

    visit promotion_path(promotion)

    fill_in '', with: 'NATAL10-0101'
    click_on 'Pesquisar'

    within 'div#search_coupon' do
      assert_text 'Código não encontrado'
    end
  end
end
