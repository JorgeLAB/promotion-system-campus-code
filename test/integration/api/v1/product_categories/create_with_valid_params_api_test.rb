require 'test_helper'

class CreateWithValidParamsApiTest < ActionDispatch::IntegrationTest

  def setup
    @product_category_params = { product_category: Fabricate.attributes_for(:product_category) }
  end

  test 'returns success status' do
    post "/api/v1/product_categories", params: @product_category_params

    assert_response :ok
  end

  test 'add a new product_category in ProductCategory' do

    assert_difference ->{ ProductCategory.count } => 1 do
      post "/api/v1/product_categories", params: @product_category_params
    end
  end

  test 'returns the last ProductCategory with valid params' do

    post "/api/v1/product_categories", params: @product_category_params

    expect_category = ProductCategory.last.as_json(only: %i(name code))

    assert_equal expect_category, body_json["product_category"]
  end
end
