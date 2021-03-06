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
    user = User.create!(name: 'IuguBot', email: 'mclovin@iugu.com.br', password: '1234567')

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: Time.zone.tomorrow, user: user)

    promotion = Promotion.new(code: 'NATAL10', name: 'Natal')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'deve ser único'
    assert_includes promotion.errors[:name], 'deve ser único'
  end

  test 'promotion coupons must start empty' do
    user = User.create!(name: 'IuguBot', email: 'mclovin@iugu.com.br', password: '1234567')

    promotion =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                   expiration_date: Time.zone.tomorrow, user: user)

    assert_empty promotion.coupons
  end

  test 'should generate coupons association' do
    user = User.create!(name: 'IuguBot', email:'mclovin@iugu.com.br', password: '1234567')

    promotion =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                   expiration_date: Time.zone.tomorrow, user: user)

    promotion.generated_coupons!

    assert_equal promotion.coupon_quantity, promotion.coupons.size
  end

  test 'coupons cannot be generated twice' do
    user = User.create!(name: 'IuguBot', email:'mclovin@iugu.com.br', password:'1234567')

    promotion =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                               code: 'NATAL10', discount_rate: 10, coupon_quantity: 1,
                               expiration_date: Time.zone.tomorrow, user: user)

    Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    assert_no_difference 'Coupon.count' do
      promotion.generated_coupons!
    end
  end

  test '.search should return by exact name' do
    user = User.create!(name: 'IuguBot', email:'mclovin@iugu.com.br', password:'1234567')

    promotion_natal =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                         code: 'NATAL10', discount_rate: 10,
                                         coupon_quantity: 1, expiration_date: Time.zone.tomorrow, user: user)

    promotion_cyber = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                        description: 'Promoção de Cyber Monday',
                                        code: 'CYBER15', discount_rate: 15,
                                        expiration_date: Time.zone.tomorrow, user: user)

    result = Promotion.search('Natal')

    assert_includes result, promotion_natal
    refute_includes result, promotion_cyber
  end

  test '.search should to return a partial search for a name' do
    user = User.create!(name: 'IuguBot', email:'mclovin@iugu.com.br', password:'1234567')

    promotion_natal =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                         code: 'NATAL10', discount_rate: 10,
                                         coupon_quantity: 1, expiration_date: Time.zone.tomorrow, user: user)

    promotion_cyber = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                        description: 'Promoção de Cyber Monday',
                                        code: 'CYBER20', discount_rate: 15,
                                        expiration_date: Time.zone.tomorrow, user: user)

    promotion_cyber_sunday = Promotion.create!(name: 'Cyber Sunday', coupon_quantity: 90,
                                               description: 'Promoção de Cyber Monday',
                                               code: 'CYBER15', discount_rate: 15,
                                               expiration_date: Time.zone.tomorrow, user: user)

    result = Promotion.search('Cyber')

    assert_includes result, promotion_cyber
    assert_includes result, promotion_cyber_sunday
    refute_includes result, promotion_natal
  end

  test '.search finds nothing' do
    user = User.create!(name: 'IuguBot', email:'mclovin@iugu.com.br', password:'1234567')

    promotion_natal =  Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                         code: 'NATAL10', discount_rate: 10,
                                         coupon_quantity: 1, expiration_date: Time.zone.tomorrow, user: user)

    promotion_cyber = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                        description: 'Promoção de Cyber Monday',
                                        code: 'CYBER15', discount_rate: 15,
                                        expiration_date: Time.zone.tomorrow, user: user)

    result = Promotion.search('Carnaval')

    assert_empty result
  end
end


