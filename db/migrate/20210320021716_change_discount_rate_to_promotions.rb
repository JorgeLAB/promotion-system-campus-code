class ChangeDiscountRateToPromotions < ActiveRecord::Migration[6.1]
  def change
    change_column :promotions, :discount_rate, :float
  end
end
