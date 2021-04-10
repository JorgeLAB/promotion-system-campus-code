require 'test_helper'

class UpdateWithInvalidParamsApiTest < ActionDispatch::IntegrationTest

  test 'returns status unprocessable_entity' do

    product_category = Fabricate(:product_category)
    new_product_category_params = { product_category: { name: nil } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params

    assert_response :unprocessable_entity
  end

  test 'returns name error message' do

    product_category = Fabricate(:product_category)
    new_product_category_params = { product_category: { name: nil } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params

    assert_includes body_json["errors"]["fields"], "name"
  end

  test 'cannot update the name' do

    old_product_category_name = "Promoção de TESTE"
    product_category = Fabricate(:product_category, name: old_product_category_name)
    new_product_category_params = { product_category: { name: nil } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params

    product_category.reload

    assert_equal product_category.name, old_product_category_name
  end

  test 'cannot update with repeated code' do

    suite_invalid_code_param

    patch "/api/v1/product_categories/#{@product_category.code}", params: @new_product_category_params

    @product_category.reload

    assert_equal @product_category.code, @old_product_category_code
  end

  test 'returns code message error with repeated code params' do

    suite_invalid_code_param

    patch "/api/v1/product_categories/#{@product_category.code}", params: @new_product_category_params

    body = JSON.parse(response.body)

    assert_includes body["errors"]["fields"], "code"
  end

  def suite_invalid_code_param
    parameter_product_category = Fabricate(:product_category)
    @old_product_category_code = "TESTE"
    @product_category = Fabricate(:product_category, code: @old_product_category_code)
    @new_product_category_params = { product_category: { code: parameter_product_category.code } }
  end
end
