Fabricator(:product_category) do
  code { sequence(:code) do |index|
          "#{Faker::Commerce.department(max: 1).upcase}#{index}"
         end
        }

  name { |attrs| "Promoção de #{attrs[:code].capitalize}" }
end

