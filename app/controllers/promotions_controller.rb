class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_promotion, only: [ :show, :edit, :update,
                                         :destroy, :search_coupon,
                                         :generate_coupon, :approve
                                       ]

  def index
    @promotions = Promotion.all
  end

	def new
		@promotion = Promotion.new
	end

	def create
		@promotion = current_user.promotions.new(promotion_params)

    if @promotion.save
      return redirect_to @promotion, success: t('.success')
    else
      flash.now[:error] = @promotion.errors.full_messages
      render :new
    end
	end

	def show; end

  def edit
    if @promotion.coupons?
      return redirect_to @promotion, notice: t('.notice')
    end
  end

  def update

    return redirect_to promotions_path if @promotion.coupons?

    if @promotion.update(promotion_params)
      return redirect_to @promotion, success: t('.success')
    else
      flash.now[:error] = @promotion.errors.full_messages
      render :edit
    end

  end

  def destroy

    if @promotion.destroy
      redirect_to promotions_path, success: t('.success')
    end
  end

  def generate_coupon
    @promotion.generated_coupons!

    flash.now[:success] = t('.success')
    render :show
  end

  def search
    @promotions = Promotion.search( params[:query] )
    render :index
  end

  def search_coupon
    @search_coupon = Coupon.search(params[:query])
    render :show
  end

  def approve
    PromotionApproval.create!(promotion: @promotion, user: current_user)
    redirect_to promotions_path, success: "Promoção #{@promotion.name} aprovada com sucesso!"
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
end

