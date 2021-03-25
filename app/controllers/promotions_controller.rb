class PromotionsController < ApplicationController
  before_action :load_promotion, only: [ :show, :edit, :update, :destroy ]

  def index
    @promotions = Promotion.all
  end

	def new
		@promotion = Promotion.new
	end

	def create
		@promotion = Promotion.new(promotion_params)

    if @promotion.save
      return redirect_to @promotion, success: t('.success')
    else
      flash.now[:error] = @promotion.errors.full_messages
      render :new
    end
	end

	def show; end

  def edit; end

  def update
    @promotion.attributes = promotion_params

    if @promotion.save
      return redirect_to @promotion, success: t('.success')
    else
      flash.now[:error] = @promotion.errors.full_messages
      render :new
    end
  end

  def destroy

    if @promotion.destroy
      redirect_to promotions_path, success: t('.success')
    end
  end

  def generate_coupon
    @promotion = Promotion.find(params[:id])
    @promotion.generated_coupons!

    render :show
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

    def defined_model
      @model = Promotion.model_name.human
    end
end

