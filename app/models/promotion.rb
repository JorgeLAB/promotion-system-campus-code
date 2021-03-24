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
    (1..coupon_quantity).each do |index|
      Coupon.create!(code: "#{code.upcase}-#{sprintf('%04d', index)}", promotion: self)
    end
  end

end

# TODO: lembrar de colocar um transaction
# TODO: Podemos implementar com bulk_insert
