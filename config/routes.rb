Rails.application.routes.draw do
  devise_for :users

	root "home#index"

	resources :promotions do
    post 'generate_coupon', on: :member
    post 'approve', on: :member
    get 'search', on: :collection
    get 'search_coupon', on: :member
  end

  resources :coupons, only: [] do
    post 'disable', on: :member
    post 'enable', on: :member
  end

  resources :product_categories

  namespace :api, constraint: ->(req) { req.format == :json } do
    namespace :v1 do
      resources :coupons, only: [:show], param: :code do
        post 'disable', on: :member
        post 'enable', on: :member
      end
      resources :product_categories, only: [:index, :show, :create], param: :code
    end
  end
end
