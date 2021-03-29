class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: true
  validates :code, presence: true,
                   uniqueness: true
  validates :discount_rate, presence: true
  validates :coupon_quantity, presence: true
  validates :expiration_date, presence: true

  def generated_coupons!
    return if coupons?

    coupons.create_with( created_at: Time.now, updated_at: Time.now )
           .insert_all( coupons_generated )
  end

  def coupons?
    coupons.any?
  end

  def custom_code(code, index)
    { code: "#{ code.upcase }-#{ sprintf('%04d', index) }" }
  end

  def coupons_generated
    (1..coupon_quantity).map { |index| custom_code(code, index) }
  end

  class << self

    def search(query)
      Promotion.all.where( 'LOWER(name) LIKE ?', "%#{query.downcase}%" )
    end

  end
end

