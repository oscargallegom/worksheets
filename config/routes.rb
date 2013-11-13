NutrientNet::Application.routes.draw do

  resources :farms do
    resources :fields do
      post :export, on: :member
      post :populateFutureCropManagement, on: :member
      post :populateFutureBMPs, on: :member
      resources :strips do
        resources :crop_rotations do
          post :duplicate, on: :member
        end
      end
    end
    post :duplicate, on: :member
    get :send_to_mapping_site, on: :member
    post :receive_from_mapping_site, on: :member
    get :review, on: :member
    get :submit, on: :member
  end

  resources :states do
    resources :counties
  end

  resources :soil_p_extractants

  resources :crop_categories do
    resources :crops
  end

  #devise_for :users    # added on 09/11
  #resources :users  # added on 09/11
  devise_for :users, :path => 'account', :controllers => {:registrations => 'users/registrations', :sessions => 'users/sessions', :unlocks => 'users/unlocks', :passwords => 'users/passwords'}

  scope "/admin" do
    resources :users do
      collection do
        put 'disable_multiple'
      end
    end
  end

  resources :project_issues, :only => [:new, :create]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  # added by Olivier
  devise_scope :user do
    root :to => 'users/sessions#new'
  #  root :to => "projects#index" # "users/sessions#new"
  end
  #root :to => 'users/sessions#new'

  match "/help", to: "static_pages#help", as: "help"

  match "/401", to: "errors#not_authorized"
  match "/404", to: "errors#not_found"
  match "/408", to: "errors#timeout"
  #match "/500", to: "errors#server_error"
end
