Rails.application.routes.draw do
  devise_for :users

	root "home#index"

	resources :promotions do
    post 'generate_coupon', on: :member
    get 'search', on: :collection
    get 'search_coupon', on: :member
  end

  resources :coupons, only: [] do
    post 'disable', on: :member
    post 'enable', on: :member
  end

  resources :product_categories
end
