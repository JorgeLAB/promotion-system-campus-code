require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign_up' do
    visit root_path
    click_on 'Cadastrar'

    assert_no_link 'Cadastrar'
    assert_text 'Criar sua conta'
    assert_text 'Já tem uma conta?'
    assert_link 'Entre', href: '/users/sign_in'

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
end

# TODO: não logar e ir para login?
# TODO: confirmar a conta?
# TODO: mandar email
# TODO: Validar qualidade da senha?
# TODO: captcha não sou um robô
# TODO: teste de sair
# TODO: verificar os errors em cadastrar
# TODO: teste de falha ao logar e ao se cadastrar
# TODO: teste de recuperar senha
# TODO: i18n do user
# TODO: testar editar user
# TODO: Adicionar nickname ao devise

