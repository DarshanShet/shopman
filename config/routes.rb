Rails.application.routes.draw do
  resources :shops
  resources :billings
  resources :receivings
  resources :items do
    collection do 
      post :import
      post :update_stock
      get :download_excel
    end
  end
  resources :customers do
    collection { post :import }
  end
  resources :vendors do
    collection { post :import }
  end
  resources :uoms do
    collection { post :import }
  end
  resources :dashbords, only: [:index]
  resources :reports, only: [:index] do
    collection do
      get :pending_amount_customers
      get :pending_amount_suppliers
      get :item_stock
    end
  end

  devise_for :users

	devise_scope :user do
	  authenticated :user do
	    root 'dashbords#index', as: :authenticated_root
	  end

	  unauthenticated do
	    root 'devise/sessions#new', as: :unauthenticated_root
	  end
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
