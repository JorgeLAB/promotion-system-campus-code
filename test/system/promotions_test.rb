require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase

  include LoginMacros

  test 'view promotions' do # seeing promotions corrigir para present continues
    # arrange
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    login_user

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

  test 'view promotion details' do # seeing a promotion corrigir para present continues
    Promotion.create!(name: 'Natal', coupon_quantity: 100,
                      description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10,
                      expiration_date: '22/12/2033')

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')
    login_user

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
    login_user

    visit root_path

    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    login_user

    visit root_path

    click_on 'Promoções'
    assert_link 'Voltar', href: "/"
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_user

    visit root_path

    click_on 'Promoções'
    click_on 'Natal'

    assert_link 'Voltar', href: "/promotions"
  end

  test 'should generate coupons' do
    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 100,
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  expiration_date: '22/12/2033')

    login_user

    visit promotion_path promotion

    click_on 'Gerar coupons'

    assert_text "Coupons gerados com sucesso!"

    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0100'
    assert_selector 'div#coupons_list li', count: promotion.coupon_quantity

    # assert_match( regexp, string, [msg] ) para verificar se os code gerados correspondem ao padrão
  end

  test 'generate coupons button need hide' do
    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 100,
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10,
                              expiration_date: '22/12/2033')
    login_user

    visit promotion_path promotion

    click_on 'Gerar coupons'

    assert_no_link 'Gerar coupons'
  end

  test 'create promotion' do
    login_user

    visit new_promotion_path

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de Coupons', with: '90'
    fill_in 'Data de término', with: I18n.l(Date.today, format: '%m-%d-%Y')
    click_on 'Criar Promoção'

    assert_text 'Promoção criada com sucesso.'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text  I18n.l(Date.today, format: '%d/%m/%Y')
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user

    visit new_promotion_path

    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'code and name must be unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    login_user

    visit new_promotion_path

    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'deve ser único', count: 2
  end

  test 'edit promotion' do
    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: I18n.l(Date.today, format: '%Y-%m-%d')
                                  )

    login_user

    visit promotion_path(promotion)

    click_on "Atualizar Promoção"

    assert_selector "form input[type=text][value='Independência']"
    assert_text 'Promoção da independência.'
    assert_selector "form input[type=text][value='Free22']"
    assert_selector "form input[type=number][value='40.0']"
    assert_selector "form input[type=number][value='200']"
    assert_selector "form input[type=date][value='#{I18n.l(Date.today, format: '%Y-%m-%d')}']"

    fill_in 'Nome', with: 'Páscoa'
    fill_in 'Descrição', with: 'Ovo de Páscoa'
    fill_in 'Data de término', with: I18n.l(Date.today.tomorrow, format: '%m-%d-%Y')

    click_on 'Atualizar Promoção'

    assert_text 'Promoção atualizada com sucesso.'
    assert_text 'Páscoa'
    assert_text 'Ovo de Páscoa'
    assert_text 'Free22'
    assert_text '40'
    assert_text '200'
    assert_text I18n.l(Date.today.tomorrow, format: '%d/%m/%Y')
  end

  test 'edit promotion cannot be blank' do
    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: I18n.l(Date.today, format: '%Y-%m-%d')
                                  )
    login_user

    visit edit_promotion_path promotion

    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de Coupons', with: ''
    fill_in 'Data de término', with: ''


    click_on 'Atualizar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'cannot edit a promotion with generated coupons' do
    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: I18n.l(Date.today, format: '%Y-%m-%d')
                                  )
    promotion.generated_coupons!
    login_user

    visit promotion_path(promotion)

    assert_no_link 'Atualizar Promoção'
  end

  test 'destroy promotion' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    login_user

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

    login_user

    visit promotions_path

    accept_confirm do
      click_on("Deletar Promoção", match: :first)
    end

    assert_text 'Promoção deletada com sucesso.'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'does not show index promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'does not show promotion details without login' do
    promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                  description: 'Promoção de Cyber Monday',
                  code: 'CYBER15', discount_rate: 15,
                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'should search field in the index promotion' do
    login_user

    visit promotions_path

    assert_selector "form input[type=search][placeholder='Pesquisar Promoção']"

    assert_button "Pesquisar"
  end

  test "can search a promotion with your exact name" do
    login_user

    promotion = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                  description: 'Promoção de Cyber Monday',
                  code: 'CYBER15', discount_rate: 15,
                  expiration_date: '22/12/2033')

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')


    visit promotions_path

    fill_in "", with: promotion.name

    click_on "Pesquisar"

    within "div#promotion_list" do
      assert_link 'Cyber Monday'
      assert_text 'Promoção de Cyber Monday'
      assert_text "15,00%"
    end

    assert_selector "dl", count: 1
  end
end

# Testaremos apenas rotas get já que são os únicos métodos permitidos para o uso de visit. Aqui vc não fará para POST, nem para PATCH, nem para DELETE ou PUT somente GET.
# Para isso devemos realizar teste de integração.
