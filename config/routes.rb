Rails.application.routes.draw do
	root to: "home#index"
	resources :promotions, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]
end
