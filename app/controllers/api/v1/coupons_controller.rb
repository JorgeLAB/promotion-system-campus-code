module Api::V1
  class CouponsController < ApiController
    before_action :load_active_coupon, only: [:show, :disable]

    def show; end

    def disable
      @coupon.disabled!
    end

    def enable
      @coupon = Coupon.disabled.find_by!(code: params[:code])
      @coupon.active!
    end

    private

    def load_active_coupon
      @coupon = Coupon.active.find_by!(code: params[:code])
    end
  end
end
