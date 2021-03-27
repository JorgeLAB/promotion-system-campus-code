class CouponsController < ApplicationController
  before_action :load_promotion, only: [ :disable, :enable ]

  def disable
    @coupon.disabled!
    redirect_to @coupon.promotion, success: "Coupom desabilitado com sucesso!"
  end

  def enable
    @coupon.active!
    redirect_to @coupon.promotion, success: "Coupom habilitado com sucesso!"
  end

  private

  def load_promotion
    @coupon = Coupon.find(params[:id])
  end
end
