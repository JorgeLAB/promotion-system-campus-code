require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase

  include LoginMacros

  def setup
    @user = login_user
  end

  test 'view promotions' do

    promotions = Fabricate.times(2, :promotion, user: @user)

    visit root_path
    click_on 'Promoções'

    promotions.each do |promotion|
      assert_text promotion.name
      assert_text promotion.description
      assert_text number_to_percentage(promotion.discount_rate, precision: 2)
    end
  end

  test 'view promotion details' do # seeing a promotion corrigir para present continues

    Promotion.create!(name: 'Natal', coupon_quantity: 100,
                      description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10,
                      expiration_date: Time.zone.tomorrow, user: @user)

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: Time.zone.tomorrow, user: @user)

    visit promotions_path

    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text I18n.l(Date.tomorrow, format: '%d/%m/%Y')
    assert_text '90'
  end

  test 'no promotion are available' do

    visit root_path

    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    visit root_path

    click_on 'Promoções'
    assert_link 'Voltar', href: "/"
  end

  test 'view details and return to promotions page' do

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: @user)

    visit root_path

    click_on 'Promoções'
    click_on 'Natal'

    assert_link 'Voltar', href: "/promotions"
  end

  test 'should generate coupons' do

    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 100,
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  expiration_date: Time.zone.tomorrow, user: @user)

    visit promotion_path promotion

    click_on 'Gerar coupons'

    assert_text "Coupons gerados com sucesso!"

    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0100'
    assert_selector 'div#coupons_list .list-group-item', count: promotion.coupon_quantity
  end

  test 'generate coupons button need hide' do

    promotion = Promotion.create!(name: 'Natal', coupon_quantity: 100,
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10,
                              expiration_date: Time.zone.tomorrow, user: @user)

    visit promotion_path promotion

    click_on 'Gerar coupons'

    assert_no_link 'Gerar coupons'
  end

  test 'create promotion'do

    visit new_promotion_path

    assert_text 'Criar Promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de Coupons', with: '90'
    fill_in 'Data de término', with: Time.zone.tomorrow
    click_on 'Criar Promoção'

    assert_text 'Promoção criada com sucesso.'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text  I18n.l(Date.tomorrow, format: '%d/%m/%Y')
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'expiration_date need to be valid' do

    visit new_promotion_path

    assert_text 'Criar Promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de Coupons', with: '90'
    fill_in 'Data de término', with: Time.zone.yesterday
    click_on 'Criar Promoção'

    assert_text 'Data inválida - data tem de ser futura'
  end

  test 'create and attributes cannot be blank' do

    visit new_promotion_path

    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'code and name must be unique' do

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: @user)

    visit new_promotion_path

    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'deve ser único', count: 2
  end

  test 'edit promotion' do

    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: Time.zone.tomorrow, user: @user)

    visit promotion_path(promotion)

    click_on "Atualizar Promoção"

    assert_text 'Editar Promoção'

    assert_selector "form input[type=text][value='Independência']"
    assert_text 'Promoção da independência.'
    assert_selector "form input[type=text][value='Free22']"
    assert_selector "form input[type=number][value='40.0']"
    assert_selector "form input[type=number][value='200']"
    assert_selector "form input[type=date][value='#{I18n.l(Date.tomorrow, format: '%Y-%m-%d')}']"

    fill_in 'Nome', with: 'Páscoa'
    fill_in 'Descrição', with: 'Ovo de Páscoa'
    fill_in 'Data de término', with: I18n.l(Date.tomorrow + 2.day, format: '%m-%d-%Y')

    click_on 'Atualizar Promoção'

    assert_text 'Promoção atualizada com sucesso.'
    assert_text 'Páscoa'
    assert_text 'Ovo de Páscoa'
    assert_text 'Free22'
    assert_text '40'
    assert_text '200'
    assert_text I18n.l(Date.tomorrow + 2.day, format: '%d/%m/%Y')
  end

  test 'edit promotion cannot be blank' do

    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: Time.zone.tomorrow, user: @user)

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
                                  expiration_date: Time.zone.tomorrow, user: @user)
    promotion.generated_coupons!

    visit promotions_path

    click_on 'Atualizar Promoção'
    assert_text 'Coupons gerados, Promoção não pode ser atualizada.'

    visit promotion_path(promotion)

    assert_no_link 'Atualizar Promoção'

  end

  test 'destroy promotion' do

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 100, expiration_date: Time.zone.tomorrow, user: @user)

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
                      expiration_date: Time.zone.tomorrow, user: @user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: Time.zone.tomorrow, user: @user)

    visit promotions_path

    accept_confirm do
      click_on("Deletar Promoção", match: :first)
    end

    assert_text 'Promoção deletada com sucesso.'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'user approves promotion' do
    user = User.create!(name: 'Jorge', email:'mc@iugu.com.br', password: '1234567')

    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: Time.zone.tomorrow, user: user
                                  )

    visit promotions_path
    accept_confirm { click_on 'Aprovar' }
    assert_text "Promoção #{promotion.name} aprovada com sucesso!"
    assert_text "Aprovada por: #{promotion.approver.email}"
    refute_link 'Aprovar'
  end

  test 'user cannot approves his promotion' do

    promotion = Promotion.create!(name: 'Independência', description: 'Promoção da independência.',
                                  code: 'Free22', discount_rate: 40, coupon_quantity: 200,
                                  expiration_date: Time.zone.tomorrow, user: @user)

    visit promotions_path
    assert_text 'Aguardando Aprovação!'
    refute_link 'Aprovar'
  end
end

# Testaremos apenas rotas get já que são os únicos métodos permitidos para o uso de visit. Aqui vc não fará para POST, nem para PATCH, nem para DELETE ou PUT somente GET.
# Para isso devemos realizar teste de integração.
# TODO: teste de integração para approves.
# TODO: teste de login da aprovação
