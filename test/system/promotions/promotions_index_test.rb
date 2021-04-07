require 'application_system_test_case'

class PromotionsIndexTest < ApplicationSystemTestCase

  include LoginMacros

  def setup
    @user = login_user
  end

  test 'have a table with promotions' do

    promotion_natal = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                        expiration_date: Time.zone.tomorrow, user: @user)

    promotion_cyber = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                                        description: 'Promoção de Cyber Monday',
                                        code: 'CYBER15', discount_rate: 15,
                                        expiration_date: Time.zone.tomorrow,  user: @user)

    visit promotions_path

    within 'div#list_promotions table' do
      within 'thead' do
        assert_text 'Nome'
        assert_text 'Descrição'
        assert_text 'Desconto'
      end

      within 'tr#promotion_1' do
        assert_text 'Natal'
        assert_text 'Promoção de Natal'
        assert_text '10,00%'
        assert_link 'Atualizar Promoção', href: edit_promotion_path(promotion_natal)
        assert_text 'Deletar Promoção'
      end

      within 'tr#promotion_2' do
        assert_text 'Cyber Monday'
        assert_text 'Promoção de Cyber Monday'
        assert_text '15,00%'
        assert_link 'Atualizar Promoção', href: edit_promotion_path(promotion_cyber)
        assert_text 'Deletar Promoção'
      end
    end
  end

  test 'should search field in the index promotion' do

    visit promotions_path

    assert_selector "form input[type=search][placeholder='Pesquisar Promoção']"

    assert_button "Pesquisar"
  end

  test "should search with your exact name" do

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: @user)

    promotion_cyber = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                        description: 'Promoção de Cyber Monday',
                                        code: 'CYBER15', discount_rate: 15,
                                        expiration_date: Time.zone.tomorrow, user: @user)

    visit promotions_path

    fill_in "", with: promotion_cyber.name

    click_on "Pesquisar"

    within "div#list_promotions table tbody" do
      assert_selector "tr", count: 1

      within 'tr#promotion_1' do
        assert_text 'Cyber Monday'
        assert_text 'Promoção de Cyber Monday'
        assert_text '15,00%'
        assert_link 'Atualizar Promoção', href: edit_promotion_path(promotion_cyber)
        assert_text 'Deletar Promoção'
      end
    end
  end

  test "should search with partial name" do

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: @user)

    promotion_sunday = Promotion.create!(name: 'Cyber Sunday', coupon_quantity: 90,
                                         description: 'Promoção de Cyber Sunday',
                                         code: 'CYBER10', discount_rate: 15,
                                         expiration_date: Time.zone.tomorrow, user: @user)

    promotion_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                         description: 'Promoção de Cyber Monday',
                                         code: 'CYBER15', discount_rate: 15,
                                         expiration_date: Time.zone.tomorrow, user: @user)
    visit promotions_path


    fill_in "", with: "Cyber"

    click_on "Pesquisar"

    within 'div#list_promotions table tbody' do
      assert_selector "tr", count: 2

      within 'tr#promotion_1' do
        assert_text 'Cyber Sunday'
        assert_text 'Promoção de Cyber Sunday'
        assert_text '15,00%'
        assert_link 'Atualizar Promoção', href: edit_promotion_path(promotion_sunday)
        assert_text 'Deletar Promoção'
      end

      within 'tr#promotion_2' do
        assert_text 'Cyber Monday'
        assert_text 'Promoção de Cyber Monday'
        assert_text '15,00%'
        assert_link 'Atualizar Promoção', href: edit_promotion_path(promotion_monday)
        assert_text 'Deletar Promoção'
      end
    end
  end

  test "should search find nothing" do

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: @user)

    promotion_sunday = Promotion.create!(name: 'Cyber Sunday', coupon_quantity: 90,
                                         description: 'Promoção de Cyber Sunday',
                                         code: 'CYBER10', discount_rate: 15,
                                         expiration_date: Time.zone.tomorrow, user: @user)

    promotion_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                         description: 'Promoção de Cyber Monday',
                                         code: 'CYBER15', discount_rate: 15,
                                         expiration_date: Time.zone.tomorrow, user: @user)
    visit promotions_path

    fill_in "", with: "Carnaval"

    click_on "Pesquisar"

    within 'div#list_promotions table tbody' do
      assert_selector "tr", count: 0
    end
  end
end
