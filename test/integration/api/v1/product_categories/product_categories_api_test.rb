require 'test_helper'

class ProductCategoriesApiTest < ActionDispatch::IntegrationTest

  test 'index should returns categories' do
    get '/api/v1/product_categories'

    assert_response :ok
  end

  test 'index should returns 10 first categories' do
    product_categories = Fabricate.times(10, :product_category)

    get '/api/v1/product_categories'
    body = JSON.parse(response.body)

    assert_equal product_categories.size, body["product_categories"].size
  end

  test 'index should returns corrects categories' do
    product_categories = Fabricate.times(10, :product_category)

    get '/api/v1/product_categories'

    expect_categories = product_categories.as_json(only: %i(name code))
    body = JSON.parse(response.body)

    assert_equal expect_categories, body["product_categories"]
  end

  test 'index should returns empty' do
    get '/api/v1/product_categories'

    body = JSON.parse(response.body)

    assert_empty body['product_categories']
  end

  test 'show should returns requested Category' do
    product_category = Fabricate(:product_category)

    get "/api/v1/product_categories/#{product_category.code}"
    body = JSON.parse(response.body)
    expect_category = product_category.as_json(only: %i(name code))

    assert_equal expect_category, body["product_category"]
  end

  test 'show returns success status' do
    product_category = Fabricate(:product_category)

    get "/api/v1/product_categories/#{product_category.code}"

    assert_response :ok
  end

  test 'show should returns error if not found' do
    product_category = Fabricate(:product_category)

    get "/api/v1/product_categories/#{product_category.code}_ERRO"

    assert_response :not_found
  end

  test 'route is invalid' do
    assert_raises ActionController::RoutingError do
      get "/api/v1/product_categorie/0"
    end
  end

  test 'create product category returns success status with valid params' do

    product_category_params = { product_category: Fabricate.attributes_for(:product_category) }

    post "/api/v1/product_categories", params: product_category_params

    assert_response :ok
  end

  test 'create product category add a new product_category with valid params' do
    product_category_params = { product_category: Fabricate.attributes_for(:product_category) }

    assert_difference ->{ ProductCategory.count } => 1 do
      post "/api/v1/product_categories", params: product_category_params
    end
  end

  test 'create product category returns the last ProductCategory with valid params' do
    product_category_params = { product_category: Fabricate.attributes_for(:product_category) }

    post "/api/v1/product_categories", params: product_category_params

    expect_category = ProductCategory.last.as_json(only: %i(name code))
    body = JSON.parse(response.body)

    assert_equal expect_category, body["product_category"]
  end

  test 'create product category returns unprocessable_entity status with invalid params' do

    product_category_params = { product_category: Fabricate.attributes_for(:product_category, name: nil) }

    post "/api/v1/product_categories", params: product_category_params

    assert_response :unprocessable_entity
  end

  test 'create product category returns error message with invalid params' do
    product_category_params = { product_category: Fabricate.attributes_for(:product_category, name: nil) }

    post "/api/v1/product_categories", params: product_category_params
    body = JSON.parse(response.body)

    assert_includes body["errors"]["fields"], "name"
  end
end
