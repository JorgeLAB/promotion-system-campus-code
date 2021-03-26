Rails.application.routes.draw do
  devise_for :users
	root to: "home#index"

	resources :promotions do
    post 'generate_coupon', on: :member
  end


  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
