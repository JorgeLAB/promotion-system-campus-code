Rails.application.routes.draw do
  devise_for :users
	root to: "home#index"

	resources :promotions do
    post 'generate_coupon', on: :member
    post 'search', on: :collection
  end

  resources :coupons, only: [] do
    post 'disable', on: :member
    post 'enable', on: :member
  end

  resources :product_categories
end
