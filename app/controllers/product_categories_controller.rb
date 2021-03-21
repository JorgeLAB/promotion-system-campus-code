class ProductCategoriesController < ApplicationController
  before_action :load_product_category, only: [:show, :edit, :update, :destroy]

  def index
    @product_categories = ProductCategory.all
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)

    product_category_save!('criada')
  end

  def show; end

  def edit; end

  def update
    @product_category.attributes = product_category_params

    product_category_save!('atualizada')
  end

  def destroy

    if @product_category.destroy
      redirect_to product_categories_path, success: 'Categoria deletada com sucesso.'
    end
  end

  private

    def product_category_params
      params.require(:product_category)
            .permit(:name, :code)
    end

    def load_product_category
      @product_category = ProductCategory.find(params[:id])
    end

    def product_category_save!(action)

      if @product_category.save
        redirect_to @product_category, success: "Categoria #{action} com sucesso."
      else
        flash[:error] = @product_category.errors.full_messages
        render :new
      end
  end
end
