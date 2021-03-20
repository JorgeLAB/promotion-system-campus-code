require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    # arrange
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')
    # act
    visit root_path
    click_on 'Promoções'

    # assert
    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    visit promotions_path

    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    visit root_path

    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path

    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path

    click_on 'Promoções'
    click_on 'Natal'

    assert_link 'Voltar', href: "/promotions"

  end

  test 'create promotion' do
    visit new_promotion_path

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar promoção'

    # assert_current_path promotion_path(Promotion.last) # pode ser omitido
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do

    visit new_promotion_path

    click_on 'Criar promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'code and name must be unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit new_promotion_path

    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar promoção'

    assert_text 'deve ser único', count: 2
  end

  test 'edit promotion' do
    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: '23/09/2023'
                                  )

    visit edit_promotion_path promotion.id

    assert_selector "form input[type=text][value='Independência']"
    assert_text 'Promoção da independência.'
    assert_selector "form input[type=text][value='Free22']"
    assert_selector "form input[type=number][value='40']"
    assert_selector "form input[type=number][value='200']"
    assert_selector "form input[type=text][value='2023-09-23']"

    fill_in 'Nome', with: 'Páscoa'
    fill_in 'Descrição', with: 'Ovo de Páscoa'
    fill_in 'Data de término', with: '4/04/2023'

    click_on 'Atualizar Promoção'

    assert_text 'Promoção atualizada com sucesso.'
    assert_text 'Páscoa'
    assert_text 'Ovo de Páscoa'
    assert_text 'Free22'
    assert_text '40'
    assert_text '200'
    assert_text '4/04/2023'
  end

  test 'destroy promotion' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    visit promotions_path

    accept_confirm do
      click_on "Deletar Promoção"
    end

    assert_text 'Promoção deletada com sucesso.'
    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'should destroy one promotion and not destroy others' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    visit promotions_path

    accept_confirm do
      click_on("Deletar Promoção", match: :first)
    end

    assert_text 'Promoção deletada com sucesso.'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end
end
