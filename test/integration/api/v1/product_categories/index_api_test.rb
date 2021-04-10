require 'test_helper'

class IndexApiTest < ActionDispatch::IntegrationTest

  test 'returns success status' do
    get '/api/v1/product_categories'

    assert_response :ok
  end

  test 'returns 10 first categories' do
    product_categories = Fabricate.times(10, :product_category)

    get '/api/v1/product_categories'

    assert_equal product_categories.size, body_json["product_categories"].size
  end

  test 'returns corrects categories' do
    product_categories = Fabricate.times(10, :product_category)

    get '/api/v1/product_categories'

    expect_categories = product_categories.as_json(only: %i(name code))

    assert_equal expect_categories, body_json["product_categories"]
  end

  test 'returns empty' do
    get '/api/v1/product_categories'

    assert_empty body_json['product_categories']
  end
end
