Rails.application.routes.draw do
	root to: "home#index"
	resources :promotions, only: [:index, :show, :new, :create]
end
