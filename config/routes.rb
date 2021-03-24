Rails.application.routes.draw do
	root to: "home#index"

	resources :promotions do
    post 'generate_coupon', on: :member
  end


  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
