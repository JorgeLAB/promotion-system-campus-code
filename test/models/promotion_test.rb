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

  test 'promotion coupons must start empty' do
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

    assert_equal promotion.coupon_quantity, promotion.coupons.size
  end

  test 'coupons cannot be generated twice' do
    promotion =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                               code: 'NATAL10', discount_rate: 10, coupon_quantity: 1,
                               expiration_date: '22/12/2033')

    Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    assert_no_difference 'Coupon.count' do
      promotion.generated_coupons!
    end
  end

  test 'should search for a promotion by name' do
    promotion =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10, coupon_quantity: 1,
                                   expiration_date: '22/12/2033')

    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')


  end
end


# TODO: O que penso é que não temos como fazer a criação em nosso sistema de um coupon por fora
