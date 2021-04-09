module Api::V1
  class ProductCategoriesController < ApiController
    def index
      @product_categories = ProductCategory.all
    end

    def show
      @product_category = ProductCategory.find_by!(code: params[:code])
    end

    def create
      @product_category = ProductCategory.new
      @product_category.attributes = params_product_category

      @product_category.save!
    rescue
      render_error(fields: @product_category.errors.messages)
    end

    private

    def params_product_category
      params.require(:product_category).permit(:name, :code)
    end
  end
end
