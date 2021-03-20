require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'view product_categories' do
    ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )
    ProductCategory.create!( name: 'Produto Natalino', code: 'NATALINO' )

    visit root_path
    click_on 'Categorias'

    assert_text 'Produto Curso'
    assert_text 'CURSO'

    assert_text 'Produto Natalino'
    assert_text 'NATALINO'
  end

  test 'view product_categories details' do
    ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    visit categories_path

    click_on 'Produto Curso'

    assert_text 'Produto Curso'
    assert_text 'CURSO'
  end

  test 'no product_categories available' do
    visit categories_path

    assert_text 'Nenhuma categoria criada.'
  end

  test 'view product_categories has a back button home' do

    visit root_path

    click_on 'Categorias'
    assert_link 'Voltar', href: '/'
  end

  test 'view product_category detail has a button to back home' do
    ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    visit root_path

    click_on 'Categorias'
    click_on 'Produto Curso'

    assert_link 'Voltar', href: "/product_categories"
  end

  test 'view create a product_category' do
    visit product_categories_path

    click_on 'Criar Categoria'

    fill_in 'Nome', with: 'Produto Curso'
    fill_in 'Código', with: 'CURSO'


  end

end
