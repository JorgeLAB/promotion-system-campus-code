class CouponsController < ApplicationController
  before_action :authenticate_user!, only: [:disable, :enable]
  before_action :load_promotion, only: [ :disable, :enable ]

  def disable
    @coupon.disabled!
    redirect_to @coupon.promotion, success: t('.success')
  end

  def enable
    @coupon.active!
    redirect_to @coupon.promotion, success: t('.success')
  end

  private

  def load_promotion
    @coupon = Coupon.find(params[:id])
  end
end
