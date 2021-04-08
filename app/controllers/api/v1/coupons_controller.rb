module Api::V1
  class CouponsController < ApiController
    def show
      @coupon = Coupon.active.find_by!(code: params[:code])
    end
  end
end
