class Promotion < ApplicationRecord
  has_many :coupons

  validates :name, presence: { message: "não pode ficar em branco" },
                   uniqueness: { message: "deve ser único" }
  validates :code, presence: { message: "não pode ficar em branco" },
                   uniqueness: { message: "deve ser único" }
  validates :discount_rate, presence: { message: "não pode ficar em branco" }
  validates :coupon_quantity, presence: { message: "não pode ficar em branco" }
  validates :expiration_date, presence: { message: "não pode ficar em branco" }

  def generated_coupons!
    return if coupons?

    coupons_generated =  (1..coupon_quantity).map do |index|
                            { code: "#{ code.upcase }-#{ sprintf('%04d', index) }" }
                          end

    coupons.create_with( created_at: Time.now, updated_at: Time.now )
           .insert_all( coupons_generated )

  end

  def coupons?
    coupons.any?
  end

end

# TODO: lembrar de colocar um transaction
# TODO: Podemos implementar com bulk_insert
