require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase

  include LoginMacros

  test 'user sign_up' do
    visit root_path
    click_on 'Cadastrar'

    assert_no_link 'Cadastrar'
    assert_text 'Criar sua conta'
    assert_text 'Já tem uma conta?'
    assert_link 'Entre', href: '/users/sign_in'

    assert_text 'Criar sua conta'

    fill_in 'Email', with: 'mclovin@iugu.com.br'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmar senha', with: '12345678'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Cadastrado com sucesso'
    assert_text 'Promoções'
    assert_text 'mclovin@iugu.com.br'
    assert_text 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'user sign_up email domain must be correct' do
    visit root_path
    click_on 'Cadastrar'

    assert_no_link 'Cadastrar'
    assert_text 'Criar sua conta'
    assert_text 'Já tem uma conta?'
    assert_link 'Entre', href: '/users/sign_in'

    fill_in 'Email', with: 'mclovin@gmail.com.br'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmar senha', with: '12345678'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text "Email possui domínio incorreto, utilize @iugu.com.br"
  end

  test 'user sign_up cannot fields blank' do

    visit new_user_registration_path

    fill_in 'Email', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirmar senha', with: ''
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Email não pode ficar em branco'
    assert_text 'Senha não pode ficar em branco'
    assert_text "Email possui domínio incorreto, utilize @iugu.com.br"

    assert_current_path user_registration_path
  end

  test 'user password should be equal password confirmation' do

    visit new_user_registration_path

    fill_in 'Email', with: 'mclovin@iugu.com.br'
    fill_in 'Senha', with: '12345678'
    fill_in 'Confirmar senha', with: ''
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Confirmar senha não é igual a senha'
  end

  test 'user sign_in' do
    user = User.create!(email: 'mclovin@iugu.com.br', password: '12345678')

    visit root_path

    click_on 'Login'

    assert_text 'Entrar'

    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password

    assert_text 'Não possui cadastro?'
    assert_link 'cadastrar-se', href: "/users/sign_up"

    check 'Lembre-me'
    assert_selector 'input[type=checkbox]:checked'

    click_on 'Confirmar'

    assert_text 'Login efetuado com sucesso!'

    assert_text user.email
    assert_current_path root_path
    assert_no_link 'Cadastrar'
    assert_no_link 'Login'
    assert_link 'Sair'
  end

  test 'user sign_out' do

    login_user

    visit promotions_path
    assert_link 'Sair', href: destroy_user_session_path
    click_on 'Sair'

    assert_current_path root_path
    assert_link 'Cadastrar'
    assert_link 'Login'
    assert_no_link 'Sair'
  end

  test 'user view forgot password' do
    user = User.create!(email: "mclovin@iugu.com.br", password: "1234567")

    visit new_user_session_path
    click_on "Esqueci minha senha"
    assert_current_path new_user_password_path

    fill_in 'Email', with: user.email
    click_on 'Enviar um email de confirmação'

    assert_current_path new_user_session_path
  end

  test 'user edit password' do
    user = User.create!(email: "mclovin@iugu.com.br", password: "1234567")
    token = user.send(:set_reset_password_token)

    visit edit_user_password_path(user, reset_password_token: token)

    fill_in 'Senha', with: '123456789'
    fill_in 'Confirmar senha', with: '123456789'

    click_on 'Trocar minha senha'

    assert_text 'Senha atualizada com sucesso'
    assert_current_path root_path
  end

end

# TODO: não logar e ir para login?
# TODO: confirmar a conta?
# TODO: mandar email
# TODO: Validar qualidade da senha?
# TODO: captcha não sou um robô
# TODO: verificar os errors em cadastrar
# TODO: teste de falha ao logar e ao se cadastrar
# TODO: i18n do user
# TODO: testar editar user
# TODO: Adicionar nickname ao devise

# TODO: Teste de sair
# TODO: Teste de falha ao registrar
# TODO: Teste de falha ao logar
# TODO: Teste o editar o usuário
# TODO: I18n do user
# TODO: incluir name no user
