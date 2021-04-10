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

  test 'update product category returns success status with valid params' do
    product_category = Fabricate(:product_category)
    new_name = "Promoção de TESTE"
    new_product_category_params = { product_category: { name: new_name } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params

    assert_response :ok
  end

  test 'update product category should returns updated category with valid params' do
    product_category = Fabricate(:product_category)
    new_name = "Promoção de TESTE"
    new_product_category_params = { product_category: { name: new_name } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params
    body = JSON.parse(response.body)
    product_category.reload
    expected_product_category = product_category.as_json(only: %i(name code))

    assert_equal expected_product_category, body["product_category"]
  end

  test 'update product category should returns status unprocessable_entity with invalid params' do

    product_category = Fabricate(:product_category)
    new_product_category_params = { product_category: { name: nil } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params

    assert_response :unprocessable_entity
  end

  test 'update product category should returns name error message with invalid params' do

    product_category = Fabricate(:product_category)
    new_product_category_params = { product_category: { name: nil } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params
    body = JSON.parse(response.body)

    assert_includes body["errors"]["fields"], "name"
  end

  test 'cannot update product category with invalid params' do
    old_product_category_name = "Promoção de TESTE"
    product_category = Fabricate(:product_category, name: old_product_category_name)
    new_product_category_params = { product_category: { name: nil } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params
    product_category.reload

    assert_equal product_category.name, old_product_category_name
  end

  test 'cannot update product category with repeated code' do
    parameter_product_category = Fabricate(:product_category)

    old_product_category_code = "TESTE"
    product_category = Fabricate(:product_category, code: old_product_category_code)
    new_product_category_params = { product_category: { code: parameter_product_category.code } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params
    product_category.reload

    assert_equal product_category.code, old_product_category_code
  end

  test 'update product category should return code message error with repeated code params' do
    parameter_product_category = Fabricate(:product_category)
    old_product_category_code = "TESTE"
    product_category = Fabricate(:product_category, code: old_product_category_code)
    new_product_category_params = { product_category: { code: parameter_product_category.code } }

    patch "/api/v1/product_categories/#{product_category.code}", params: new_product_category_params

    body = JSON.parse(response.body)

    assert_includes body["errors"]["fields"], "code"
  end

  test 'destroy a product category returns no_content status' do
    product_category = Fabricate(:product_category)

    delete "/api/v1/product_categories/#{product_category.code}"

    assert_response :no_content
  end

  test 'destroy a product category should remove of ProductCategory' do
    product_category = Fabricate(:product_category)

    assert_difference ->{ ProductCategory.count } => -1 do
      delete "/api/v1/product_categories/#{product_category.code}"
    end
  end

  test 'can not destroy a product category with invalid code' do
    product_category = Fabricate(:product_category)

    assert_no_changes "ProductCategory.count" do
      delete "/api/v1/product_categories/#{product_category.code}_INVALID"
    end
  end

  test 'destroy a invalid product category returns error message' do
    product_category = Fabricate(:product_category)

    delete "/api/v1/product_categories/#{product_category.code}_INVALID"

    body = JSON.parse(response.body)

    assert_equal "Não encontrado", body["errors"]["message"]
  end
end
