MoneyMinder::Application.routes.draw do
  post  'purchases' => 'purchases#create', :as => :purchases
  post  'expected_purchase/:id/purchases' => 'purchases#create_from_expected_purchase', :as => :expected_purchase_purchases
  get   'purchases/new' => 'purchases#new', :as => :new_purchase
  
  get   'virtual_account/:name/purchases/new' => 'purchases#new_from_virtual_account', :as => :new_purchase_from_virtual_account
  get   'expected_purchase/:id/purchase/new' => 'purchases#new_from_expected_purchase', :as => :new_purchase_from_expected_purchase

  get   'virtual_accounts' => 'virtual_accounts#index', :as => :virtual_accounts
  
  get   'expected_purchases' => 'expected_purchases#index', :as => :expected_purchases
  delete  'expected_purchase/:id' => 'expected_purchases#dismiss', :as => :expected_purchase
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
end
