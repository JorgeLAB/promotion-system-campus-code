class PromotionsController < ApplicationController
  before_action :load_promotion, only: [:show, :edit, :update, :destroy]

  def index
    @promotions = Promotion.all
  end

	def new
		@promotion = Promotion.new
	end

	def create
		@promotion = Promotion.new(promotion_params)

    promotion_save!('criada')
	end

	def show; end

  def edit; end

  def update
    @promotion.attributes = promotion_params

    promotion_save!('atualizada')
  end

  def destroy

    if @promotion.destroy
      redirect_to promotions_path, success: 'Promoção deletada com sucesso.'
    end
  end

	private

    def promotion_params
    	params.require(:promotion)
            .permit(:name, :description,
                    :code,:discount_rate,
                    :coupon_quantity,:expiration_date
                    )
    end

    def load_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_save!(action)

      if @promotion.save
        redirect_to @promotion, success: "Promoção #{action} com sucesso."
      else
        flash[:error] = @promotion.errors.full_messages
        render :new
      end
    end
end
