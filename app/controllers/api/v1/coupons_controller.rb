module Api
  module V1
    class CouponsController < ApiController
      def show
        @coupon = Coupon.find_by(code: params[:code])
        render json: @coupon.to_json
      end
    end
  end
end
