Zigzeg::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  #match '/auth/:provider/callback' => 'authentications#create'
#  match "/signout" => "sessions#destroy", :as => :signout

  mount Resque::Server, :at => "/resque"

  match "/signin" => "sessions#login", :as => :login
  match "/signout" => "sessions#logout", :as => :logout
  match "/signup" => "registration#signup", :as => :signup
  match "/signup_success" => "registration#signup_success", :as => :signup_success
  match "/forget_password" => "sessions#forget_password", :as => :forget_password
  match "/password_reset" => "sessions#password_reset", :as => :password_reset
  match "/confirm" => "sessions#confirm", :as => :confirm
  match "/general_save" => "dashboard#general-save"
  match "/template_viewer" => "templates#view"
  match "/search_autocomplete" => "listings#search_autocomplete"
  match "/search" => "listings#search"
  match "/terms" => "pages#terms", :as => :terms
  match "/about" => "pages#about", :as => :about
  match "/careers" => "pages#careers", :as => :careers
  match "/contacts" => "pages#contacts", :as => :contacts
	match "/login" => "login#login", :as => :login
  match "/forgot" => "login#forgot", :as => :forgot
  match "/errors" => "pages#errors", :as => :errors
  match "/help" => "pages#help", :as => :help
  match "/contactus" => "pages#contactus", :as => :contactus
  match "/support" => "pages#support", :as => :support
  match "/showmore" => "listings#showmore", :as => :showmore
  match "/ratethis" => "ratings#ratethis", :as => :ratethis
  match "/zigthis" => "listings#zigthis", :as => :zigthis

  resources :pages do
    collection do
      post 'contacts'
    end
  end
  
  resource :sessions do
    collection do
      get 'check_session'
    end
  end

  resource :welcome, :controller => :welcome do
    collection do
      get :create_page
      post :create_page
      get :category_page
      post :category_page
      get :gallery_page
      post :gallery_page
      post :upload_profile
      post :upload_gallery
      post :update_gallery
      get :complete
      get :load_select_subcategories
    end
  end

  resource :registration, :controller => :registration do
    collection do
      get :business_reg
      get :update_package_information
    end
  end

  resources :maps

  resource :dashboards do
    collection do
      get  'general'
      post  'general'
      get  'personal'
      post  'personal'
      get  'picture'
      post  'picture'
      get  'education'
      post  'education'
      get  'contact'
      post  'contact'
      get  'settings'
      post  'settings'
    end
  end

  resource :account, :controller => "account" do
    collection do
      get 'ziglist'
      get 'settings'
      post 'settings'
      get 'welcome'
      get 'load_select_cities'
      get 'load_select_states'
      get 'load_select_sections'
      post 'upload_profile'
      post 'change_password'
      post 'remove_ziglist'
    end

  end

  namespace :account do
    resources :messages do
      collection do
        get "ajax_get_message_threads"
        post "remove_messages"
      end
    end
  end


  resource :business, :controller => "business" do
    collection do
      get 'myplace'
      get 'myevents'
      get 'myoffers'
      get 'account'
      get 'ziglist'
      get 'settings'
      post 'settings'
      post 'change_password'
      post 'update_place'
      post 'update_location'
      post 'upload_images_place'
      post 'update_profile_image'
      get 'searchaddress'
      get 'edit_picture'
      post 'upload_gallery'
      post 'update_gallery'
      post 'upload_profile'
      post 'upload_company_profile'
      get 'tag_suggestions'
      get 'publish'
      get 'delete_images'
      get 'show_sub_category'
      post 'update_category'
      get 'show_category_features'
    end
  end

  namespace :business do
    resources :messages do
      collection do
        get "ajax_get_message_threads"
        post "remove_messages"
      end
    end

    resources :events do
      collection do
        post 'remove'
        get 'searchaddress'
        get 'edit_picture'
        post 'upload_gallery'
        post 'update_gallery'
        post 'upload_profile'        
      end
      member do
        get 'publish'
        get 'locations'
        get 'pricing'
        get 'gallery'
        post 'upload_images'
      end
    end

    resources :offers do
      collection do
        post 'remove'
        get 'searchaddress'
        get 'edit_picture'
        post 'upload_gallery'
        post 'update_gallery'
        post 'upload_profile'        
      end
      
      member do
        get 'locations'
        get 'pricing'
        get 'gallery'
        get 'publish'
        post 'upload_images'
      end
    end
        
    resources :deals do
      collection do
        get 'locations'
      end
    end
  end

  resource :admin, :controller => "admin" do
    collection do
      get "alerts"
      get "company"
      get "system"
      get "map"
      get "businesses"
      get "sales"
      get "alert_details"
      get "alert_done"
      get "system"
      get "load_select_subcategories"
    end
  end

  namespace :admin do
    resources :maps
    resources :logs
    resources :statistics
    resources :email_templates
    resources :packages do
      collection do
        get "newdiscount"
        post "create_discount"
      end
    end
    resources :advertisers do
      member do
        get "businessdetails"
      end
      
      collection do
        get "eventdetails"
      end
    end
    
    resources :announcements do
      collection do
        post "remove_announcements"
      end
    end
    resources :categories do
      collection do
        post "remove_categories"
      end
    end
    resources :administrators do
      collection do
        post "remove_admins"
      end
    end

    resources :users do 
      member do
        get "userdetails"
      end
      
      collection do
        post 'suspend'
        get 'activate'
      end
    end
    
    resources :messages do
      collection do
        get "ajax_get_message_threads"
        post "remove_messages"
      end
    end
    resource :system, :controller => :system do
      collection do
        get "section_lock"
        get "premium_feature_settings"
        get "system_templates"
        get "global_settings"
        post "global_settings"
      end
    end
  end

  namespace :cms do
    resources :users do
      member do
        get "toggle_status"
      end

      resources :listings

      member do
        get "places"
        get "events"
        get "deals"
      end

      collection do
        get "check_username"
        get "search"
      end
    end

    resources :listings
    resources :categories
    resources :communications do
      collection do
        get 'sent'
        get 'ajax_fetch_user'
        post 'create_announcement'
      end
    end
    resources :maps
    resources :rates
    resources :statistics
    resources :advertisements
    resources :blogs
  end

  resources :favorites do
    collection do
      get 'recent'
      get 'category'
    end
  end

  resources :messages do 
    collection do
      post "reply_contactus"
    end
  end

  resources :places do
    collection do
      get 'more_pictures'
    end
  end

  resources :users
  resources :histories
  resources :listings do
    collection do
      post 'contactus'
      post 'contact_zigzeg'
      post 'reportthis'
      post 'create_shout'
    end

    resources :events, :deals
  end

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
  root :to => "listings#index"

  match "/tags/:tag"                  => "listings#tagsearch"
#  match "/auth/:provider/callback"    => "sessions#create"
  match '/auth/:provider/callback', :to => 'sessions#create'
  match "*name/deals"                 => "places#list_deals"
  match "*name/deals/:name"           => "deals#show"
  match "*name/events"                => "places#list_events"
  match "*name/events/:name"          => "events#show"
  match "*name/announcements/:id"     => "announcements#show"
  match "*name"                       => "places#show"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'