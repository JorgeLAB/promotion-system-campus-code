json.product_categories do
  json.array! @product_categories, :name, :code
end
