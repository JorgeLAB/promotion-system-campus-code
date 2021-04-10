require 'test_helper'

class CreateWithInvalidParamsApiTest < ActionDispatch::IntegrationTest

  def setup
    invalid_attributes = Fabricate.attributes_for(:product_category, name: nil)
    @invalid_product_category_params = { product_category: invalid_attributes }
  end

  test 'returns unprocessable_entity status' do

    post "/api/v1/product_categories", params: @invalid_product_category_params

    assert_response :unprocessable_entity
  end

  test 'returns error message' do

    post "/api/v1/product_categories", params: @invalid_product_category_params

    assert_includes body_json["errors"]["fields"], "name"
  end

  test 'cannot changes ProductCategory' do

    assert_no_changes "ProductCategory.count" do
      post "/api/v1/product_categories", params: @invalid_product_category_params
    end
  end
end
