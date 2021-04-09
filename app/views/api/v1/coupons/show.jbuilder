json.coupon do
  json.discount_rate @coupon.discount_rate
  json.expiration_date @coupon.expiration_date.strftime("%d/%m/%Y")
end
