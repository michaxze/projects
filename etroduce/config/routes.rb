ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  Jammit::Routes.draw(map)

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  map.resources :jobs, :controller => "jobs"
  map.login    'login', :controller => "sessions", :action => "create"
  map.logout    'logout', :controller => "sessions", :action => "stop"
  map.forgot_password 'forgot_password', :controller => "sessions", :action => "forgot_password"
  map.password_reset 'password_reset', :controller => "sessions", :action => "password_reset"
  map.dashboard    'dashboard', :controller => "home", :action => "dashboard"
  map.signup    'signup', :controller => "home", :action => "signup"
  map.aboutus   'aboutus', :controller => "home", :action => "aboutus"
  map.contactus 'contactus', :controller => "home", :action => "contactus"
  map.activate  'activate', :controller => "home", :action => "activate"
  map.activate_na  'activate_na', :controller => "home", :action => "activate_na"
  map.profile 'profile', :controller => "users", :action => "profile"
  map.confirm 'confirm', :controller => "home", :action => "confirm"
  map.settings 'settings', :controller => "users", :action => "settings"

  map.connect 'smshandler', :controller => "smshandlers"
  map.resources :sessions, :controller => "sessions", :collection => { :stop => :get }
  map.resources :users, :controller => "users",
                :collection => { :stop => :get, :details => :get},
                :member => { :resetpassword => :get, :change_password => :post, :profile => :get }

  map.account 'account', :controller => "accounts", :action => "index"
  map.resources :accounts, :controller => "accounts", :member => { :updateinfo => :post}
  map.resources :myopportunities, :controller => "myopportunities"
  
  map.resources :home, :controller => "home", :member => { :updateinfo => :post }, :collection => { :pageviewer => :get}

  map.resources :opportunities, 
                :controller => "opportunities",
                :member => { :view => :get, :respond => :get, :refer => :get, :share_etroduce => :get, :remove_image => :post },
                :collection => { :jobs => :get,
                                 :search_email => :get,
                                 :search_byname => :get,
                                 :personals => :get,
                                 :housing => :get,
                                 :forsale => :get,
                                 :deals => :get,
                                 :show_respond => :post,
                                 :show_refer => :post,
                                 :show_respond_na => :post
                               }
  map.resources :contact_lists, :controller => "contact_lists",
                :collection => { :add_contacts => :post }
  map.resources :messages, :controller => "messages",
                :collection => { :markasunread => :post }
  map.resources :contacts, :controller => "contacts",
                :collection => { :send_request => :post,
                                 :friends => :get,
                                 :your_requests => :get,
                                 :friend_requests => :get,
                                 :show_add_list => :get,
                                 :create_list => :post,
                                 :remove_fromlist => :get,
                                 :show_edit_list => :get,
                                 :delete_fromlist => :post,
                                 :cancel_invitation => :get,
                                 :resend_invitation => :get,
                                 :accept_invitation => :get
                                 }
  map.resources :invitations, :controller => "invitations"
  map.resources :admins, :controller => "admins"

  map.resources :payment_notifications
  map.current_cart 'cart', :controller => 'carts', :action => 'show', :id => 'current'
  map.resources :line_items
  map.resources :carts
    
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

#  map.sub_root '', :controller => 'opportunities', :action => 'index', :conditions => { :subdomain => /.+/ }
  map.auth 'auth/:provider/callback', :controller => 'sessions', :action => 'facebook_login'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':username', :controller => "users", :action => "profile"
end
