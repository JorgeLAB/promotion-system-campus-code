require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test 'attribute can not be blank' do
    promotion = Promotion.new

    refute promotion.valid? # não precisa criar no banco para verficar se é válido
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em branco'
  end

  test 'code and name must be uniq' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                  expiration_date: '22/12/2033')

    promotion = Promotion.new(code: 'NATAL10', name: 'Natal')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'deve ser único'
    assert_includes promotion.errors[:name], 'deve ser único'
  end

  test 'promotion coupons must begin empty' do
    promotion =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                               code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                               expiration_date: '22/12/2033')

    assert_empty promotion.coupons
  end

  test 'should generate coupons association' do
    promotion =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                   expiration_date: '22/12/2033')

    promotion.generated_coupons!

    assert_equal 100, promotion.coupons.size
  end
end
