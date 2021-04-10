require 'test_helper'

class DestroyApiTest < ActionDispatch::IntegrationTest

  def setup
    @product_category = Fabricate(:product_category)
  end

  test 'returns no_content status' do
    delete "/api/v1/product_categories/#{@product_category.code}"

    assert_response :no_content
  end

  test 'should remove element by ProductCategory' do

    assert_difference ->{ ProductCategory.count } => -1 do
      delete "/api/v1/product_categories/#{@product_category.code}"
    end
  end

  test 'cannot destroy with invalid code' do

    assert_no_changes "ProductCategory.count" do
      delete "/api/v1/product_categories/#{@product_category.code}_INVALID"
    end
  end

  test 'returns error message with invalid code' do

    delete "/api/v1/product_categories/#{@product_category.code}_INVALID"

    assert_equal "Não encontrado", body_json["errors"]["message"]
  end
end
