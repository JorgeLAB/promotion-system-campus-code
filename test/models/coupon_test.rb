require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test '.search should return by exact coupon' do
    user = User.create(email: 'mclovin@iugu.com.br', password: '1234567')

    promotion_natal =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                         code: 'NATAL10', discount_rate: 10,
                                         coupon_quantity: 10, expiration_date: '22/12/2033', user: user)

    natal_coupon_1 = Coupon.create!(code:'NATAL10-0001', promotion: promotion_natal )
    natal_coupon_2 = Coupon.create!(code:'NATAL10-0002', promotion: promotion_natal )

    search_result = Coupon.search('NATAL10-0001')

    assert_equal search_result, natal_coupon_1
  end

  test '.search finds nothing' do
    user = User.create(email: 'mclovin@iugu.com.br', password: '1234567')

    promotion_natal =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                     code: 'NATAL10', discount_rate: 10,
                                     coupon_quantity: 10, expiration_date: '22/12/2033', user: user)

    natal_coupon_1 = Coupon.create!(code:'NATAL10-0001', promotion: promotion_natal )
    natal_coupon_2 = Coupon.create!(code:'NATAL10-0002', promotion: promotion_natal )

    search_result = Coupon.search('NATAL10-0003')

    assert_equal search_result, 'Código não encontrado'
  end

  test '.search invalid code' do
    user = User.create(email: 'mclovin@iugu.com.br', password: '1234567')

    promotion_natal =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                     code: 'NATAL10', discount_rate: 10,
                                     coupon_quantity: 10, expiration_date: '22/12/2033', user: user)

    natal_coupon_1 = Coupon.create!(code:'NATAL10-0001', promotion: promotion_natal )
    natal_coupon_2 = Coupon.create!(code:'NATAL10-0002', promotion: promotion_natal )

    search_result = Coupon.search('NATAL100002')

    assert_equal search_result, 'Código inválido'
  end
end

# Happy path: quando retorna o coupon que quero
# Quando não carrega nenhum coupon, caso em que o código não existe.
# Código possui formato inválido
