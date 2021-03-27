require 'test_helper'

class ProductCategoryFlowTest < ActionDispatch::IntegrationTest

  include LoginMacros

  test 'cannot create a product_category without login' do

    assert_no_changes 'ProductCategory.count' do
      post product_categories_path, params: {
        product_category: { name: 'Produto Curso', code: 'CURSO' }
      }
    end

    assert_redirected_to new_user_session_path
  end

  test 'cannot update a product_category without login' do
    category = ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    assert_no_changes -> { category.name } do
      patch product_category_path(category), params: {
        product_category: { name: 'Produto Carnaval', code: 'CARNAVAL' }
      }
    end

    assert_redirected_to new_user_session_path
  end

  test 'cannot destroy a product_category without login' do
    category = ProductCategory.create!( name: 'Produto Curso', code: 'CURSO' )

    assert_no_changes 'ProductCategory.count' do
      delete product_category_path(category)
    end

    assert_redirected_to new_user_session_path
  end
end
