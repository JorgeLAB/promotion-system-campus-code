require 'test_helper'

class ShowApiTest < ActionDispatch::IntegrationTest

  def setup
    @product_category = Fabricate(:product_category)
  end

  test 'returns requested ProductCategory' do

    get "/api/v1/product_categories/#{@product_category.code}"

    expect_category = @product_category.as_json(only: %i(name code))

    assert_equal expect_category, body_json["product_category"]
  end

  test 'returns success status' do

    get "/api/v1/product_categories/#{@product_category.code}"

    assert_response :ok
  end

  test 'returns error if not found' do

    get "/api/v1/product_categories/#{@product_category.code}_ERRO"

    assert_response :not_found
  end

  test 'returns message error if not found' do

    get "/api/v1/product_categories/#{@product_category.code}_ERRO"

    assert_equal "Não encontrado", body_json['errors']['message']
  end

  test 'with route invalid' do
    assert_raises ActionController::RoutingError do
      get "/api/v1/product_categorie/0"
    end
  end
end
