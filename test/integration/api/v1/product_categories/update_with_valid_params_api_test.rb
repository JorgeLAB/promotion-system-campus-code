require 'test_helper'

class UpdateWithValidParamsTest < ActionDispatch::IntegrationTest

  def setup
    @product_category = Fabricate(:product_category)
    @new_name = "Promoção de TESTE"
  end

  test 'returns success status' do

    new_product_category_params = { product_category: { name: @new_name } }

    patch "/api/v1/product_categories/#{@product_category.code}", params: new_product_category_params

    assert_response :ok
  end

  test 'returns updated product category' do
    new_product_category_params = { product_category: { name: @new_name } }

    patch "/api/v1/product_categories/#{@product_category.code}", params: new_product_category_params
    @product_category.reload

    expected_product_category = @product_category.as_json(only: %i(name code))

    assert_equal expected_product_category, body_json["product_category"]
  end
end
