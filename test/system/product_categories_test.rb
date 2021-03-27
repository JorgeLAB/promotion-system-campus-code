require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase

  include LoginMacros

  test 'viewing product_categories index' do
    ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )
    ProductCategory.create!( name: 'Produto Natalino', code: 'NATALINO' )

    login_user

    visit root_path
    click_on 'Categorias'

    assert_text 'Produto Curso'
    assert_text 'CURSO'

    assert_text 'Produto Natalino'
    assert_text 'NATALINO'
  end

  test 'no product_categories available' do
    login_user

    visit product_categories_path

    assert_text 'Nenhuma categoria cadastrada.'
  end

  test 'cannot view product_categories index without login' do
    visit product_categories_path

    assert_current_path new_user_session_path
  end

  test 'view product_categories has a back button home' do
    login_user

    visit root_path

    click_on 'Categorias'
    assert_link 'Voltar', href: '/'
  end

  test 'view product_categories details' do
    login_user

    ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    visit product_categories_path

    click_on 'Produto Curso'

    assert_text 'Produto Curso'
    assert_text 'CURSO'
  end

  test 'view product_category details has a button to back home' do
    login_user

    ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    visit root_path

    click_on 'Categorias'
    click_on 'Produto Curso'

    assert_link 'Voltar', href: "/product_categories"
  end

  test 'cannot view product_category details without login' do
    category = ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    visit product_category_path(category)

    assert_current_path new_user_session_path
  end

  test 'viewing create a product_category' do
    login_user

    visit product_categories_path

    click_on 'Nova Categoria'

    fill_in 'Nome', with: 'Produto Curso'
    fill_in 'Código', with: 'CURSO'
    click_on 'Criar Categoria'

    assert_text 'Categoria criada com sucesso.'
    assert_text 'Produto Curso'
    assert_text 'CURSO'
  end

  test 'cannot view new form without login' do
    visit new_product_category_path

    assert_current_path new_user_session_path
  end

  test 'create and attributes cannot be blank' do
    login_user

    visit new_product_category_path

    click_on 'Criar Categoria'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'code and name product_category must be unique' do
    login_user

    ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    visit new_product_category_path

    fill_in 'Nome', with: 'Produto Curso'
    fill_in 'Código', with: 'CURSO'
    click_on 'Criar Categoria'

    assert_text 'deve ser único', count: 2
  end

  test 'view product_categories must has a button category edit' do
    login_user

    product_curso = ProductCategory.create!(name: 'Produto Curso', code: 'CURSO')

    visit product_categories_path

    assert_link 'Atualizar Categoria', href: edit_product_category_path(product_curso.id)
  end

  test 'edit product_category' do
    login_user

    product_category = ProductCategory.create!(name: 'Produto Curso', code: 'CURSO')

    visit edit_product_category_path product_category.id

    assert_selector "form input[type=text][value='Produto Curso']"
    assert_selector "form input[type=text][value='CURSO']"

    fill_in 'Nome', with: 'Produto Carnaval'
    fill_in 'Código', with: 'CARNAVAL'

    click_on 'Atualizar Categoria'

    assert_text 'Categoria atualizada com sucesso.'
    assert_text 'Produto Carnaval'
    assert_text 'CARNAVAL'
  end

  test 'edit product_category attributes cannot be blank' do
    login_user

    product_category = ProductCategory.create!(name: 'Produto Curso', code: 'CURSO')

    visit edit_product_category_path(product_category)

    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''

    click_on 'Atualizar Categoria'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'cannot view edit form without login' do
    product_category = ProductCategory.create!(name: 'Produto Curso', code: 'CURSO')

    visit edit_product_category_path(product_category)

    assert_current_path new_user_session_path
  end

  test 'destroy product_category' do
    login_user

    product_curso = ProductCategory.create!(name: 'Produto Curso', code: 'CURSO')

    visit product_categories_path

    accept_confirm do
      click_on "Deletar Categoria"
    end

    assert_text 'Categoria deletada com sucesso.'
    assert_text 'Nenhuma categoria cadastrada.'
  end

  test 'should destroy one product_category and not destroy others' do
    login_user

    ProductCategory.create!(name: 'Produto Curso', code: 'CURSO')
    ProductCategory.create!(name: 'Produto Carnaval', code: 'CARNAVAL')

    visit product_categories_path

    accept_confirm do
      click_on("Deletar Categoria", match: :first)
    end

    assert_text 'Categoria deletada com sucesso.'

    assert_text 'CARNAVAL'
  end
end
