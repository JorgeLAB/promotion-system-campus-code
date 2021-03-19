class Promotion < ApplicationRecord
  validates :name, presence: { message: "não pode ficar em branco" },
                   uniqueness: { message: "deve ser único" }
  validates :code, presence: { message: "não pode ficar em branco" },
                   uniqueness: { message: "deve ser único" }
  validates :discount_rate, presence: { message: "não pode ficar em branco" }
  validates :coupon_quantity, presence: { message: "não pode ficar em branco" }
  validates :expiration_date, presence: { message: "não pode ficar em branco" }
end
