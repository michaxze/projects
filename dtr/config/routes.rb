Dtr::Application.routes.draw do
  devise_for :admin
  devise_for :users,  :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }
  resources :home, :only => :index
  resources :admins, :only => :index
  match '/auth/:provider/callback', to: 'sessions#create'  
  root :to => "home#index"

  match '/settime' => "home#settime"
  match "/monthly" => "home#monthly"
  match '/token' => 'home#token', :as => :token
end
