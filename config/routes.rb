TeHablo::Application.routes.draw do

  get "sites/index"
  get "sites/features"
  get "sites/contact"
  get "sites/about"
  mount StripeEvent::Engine => '/webhooks/event'


  resources :calls do
    member do
      get :print
    end
  end

  controller :rates do
    get 'check_rates' => :check_rates
  end

  controller :receipts do
    post 'quick_recharge' => :quick_recharge

  end

  controller :direct do
    get 'direct/make' => :make
    get 'direct/hangup' => :hangup
    get 'direct/gather' => :gather
    get 'direct/fallback' => :fallback
    get 'direct/register_zoiper' => :register_zoiper
  end

  controller :sessions do
    get 'login' => :new
    get 'recover' => :recover
    get 'register' => :create_account
    post 'login' => :create
    post 'register' => :register
    post 'forgot_password' => :forgot_password
    delete 'logout' => :destroy
  end

  resources :users, :dashboard,  :direct, :receipts, :calling_ids, :recharges, :rates


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'sites#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
