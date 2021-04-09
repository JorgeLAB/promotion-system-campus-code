Fabricator(:promotion) do
  name { Faker::Commerce.product_name }
  description { Faker::Lorem.paragraph(sentence_count: 2) }
  coupon_quantity { Faker::Number.within(range: 1..100) }
  discount_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  code { Faker::Commerce.promotion_code.upcase }
  expiration_date { 3.days.from_now }
  user
end


