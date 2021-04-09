Fabricator(:product_category) do
  code { Faker::Commerce.department(max: 1).upcase }
  name { |attrs| "Promoção de #{attrs[:code].capitalize}" }
end

