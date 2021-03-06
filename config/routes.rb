Meejian::Application.routes.draw do
  root to: 'home#index'
  get '/page/:page', to: 'home#index'

  devise_for :users, skip: [:sessions],
  controllers:  {omniauth_callbacks: "omniauth_callbacks"}

  as :user do
    get 'login' => 'devise/sessions#new', as: :new_user_session
    post 'login' => 'devise/sessions#create', as: :user_session
    delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :users, only: [:show, :edit, :update, :index] do
    get 'page/:page', action: :show, on: :member
    get 'page/:page', action: :index, on: :collection
    resources :auths, only: [:index, :destroy]
  end

  resources :messages, only: [:index] do
    get 'page/:page', action: :index, on: :collection
    collection do
      post 'readall'
    end
  end

  resources :products

  resources :categories

  resources :topics do
    resources :interviews, except: [:index] do
      member do
        post 'like'
        post 'share'
      end
      resources :comments, only: [:create, :destroy]
      resources :answers do
        member do
          post 'recommend_toggle'
        end
      end
    end
  end

  get '/search', to: 'site#search', as: :search
  get '/inviteds', to: 'site#inviteds'
  get '/jobs', to: 'site#jobs'
  match "/404", :to => "site#not_found"
  match "/403", :to => "site#forbidden"
  match "/500", :to => "site#server_error"

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
