Kuatro::Application.routes.draw do

  match "blogs/:code" => "blogs#viewpost"
  match 'home' => "index#index"
  match 'about' => "index#about"
  match 'love_letters' => "index#love_letters"
  match 'packages' => "index#packages"
  match 'contactus' => 'index#contactus'
  match 'gallery' => 'index#gallery'

  namespace :admins do
    resources :blogs do
      member do
        get "delete"
      end
      
    end
  end

  resources :admins, :controller => "admins" do    
    collection do
      post 'login'
      get 'login'
      get 'dashboard'
      post 'feature'

      get 'featured'
      get 'logout'
      get 'delete_featured'
      get 'gallery'
      get 'newcategory'
      get 'newalbum'
      post 'newcategory'
      post 'newalbum'      
      post 'addpicture'
      get 'delete_picture'
      get 'delete_album'
      get 'delete_category'
      get 'letters'
      get 'add_letter'
      get 'edit_letter'
      post 'edit_letter'
      post 'add_letter'
      get 'delete_letter'
      post 'update_letter'
      get 'view_letter'
      
    end
  end

  
  resources :blogs
  resources :users





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
  root :to => "index#index"

  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase

  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
