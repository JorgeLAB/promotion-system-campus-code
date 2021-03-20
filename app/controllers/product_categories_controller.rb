class ProductCategoriesController < ApplicationController
  def index
    @product_categories = ProductCategory.all
  end

  def show
    @product_category = ProductCategory.find(params[:id])
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)

    if @product_category.save
      redirect_to @product_category, success: "Categoria criada com sucesso."
    else
      flash[:error] = @product_category.errors.full_messages
      render :new
    end
  end

  def edit
    @product_category = ProductCategory.find(params[:id])
  end

  def update
    @product_category = ProductCategory.find(params[:id])
    @product_category.attributes = product_category_params

    if @product_category.save
      redirect_to @product_category, success: "Categoria atualizada com sucesso."
    end
  end

  def destroy
    @product_category = ProductCategory.find(params[:id])

    if @product_category.destroy
      redirect_to product_categories_path, success: 'Categoria deletada com sucesso.'
    end
  end

  private

  def product_category_params
    params.require(:product_category).permit(:name, :code)
  end
end
