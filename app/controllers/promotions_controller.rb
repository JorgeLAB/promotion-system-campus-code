class PromotionsController < ApplicationController
	def new
		@promotion = Promotion.new
	end

	def create
		@promotion = Promotion.new(promotion_params)

		return redirect_to @promotion if @promotion.save

    flash[:error] = @promotion.errors.full_messages
    render :new
	end

	def index
		@promotions = Promotion.all
	end

	def show
		@promotion = Promotion.find(params[:id])
	end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])
    @promotion.attributes = promotion_params

    if @promotion.save
      redirect_to @promotion,success: 'Promoção atualizada com sucesso.'
    end
  end

  def destroy
    @promotion = Promotion.find(params[:id])

    if @promotion.destroy
      redirect_to promotions_path, success: 'Promoção deletada com sucesso.'
    end
  end

	private

	def promotion_params
		params.require(:promotion).permit(:name, :description, :code, :discount_rate, :coupon_quantity, :expiration_date )
	end
end
