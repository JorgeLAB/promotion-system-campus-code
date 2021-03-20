require "test_helper"

class ProductCategoryTest < ActiveSupport::TestCase

  test 'attribute name cannot be blank' do
    product_category = ProductCategory.new

    refute product_category.valid?

    assert_includes product_category.errors[:name], "não pode ficar em branco"
  end

  test 'attribute code cannot be blank' do
    product_category = ProductCategory.new

    refute product_category.valid?

    assert_includes product_category.errors[:code], "não pode ficar em branco"
  end

  test 'attribute name must be unique' do
    ProductCategory.create!(name: "Produto Carnaval", code: "CARNAVAL")
    product_category = ProductCategory.new( name: "Produto Carnaval" )

    refute product_category.valid?

    assert_includes product_category.errors[:name], "deve ser único"
  end

  test 'attribute code must be unique' do
    ProductCategory.create!(name: "Produto Carnaval", code: "CARNAVAL")
    product_category = ProductCategory.new( code: "CARNAVAL" )

    refute product_category.valid?

    assert_includes product_category.errors[:code], "deve ser único"
  end
end
