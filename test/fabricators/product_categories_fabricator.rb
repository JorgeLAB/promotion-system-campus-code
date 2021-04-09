Fabricator(:product_category) do
  code { Faker::Commerce.unique.department(max: 1).upcase }
  name { |attrs| "Promoção de #{attrs[:code].capitalize}" }
end

