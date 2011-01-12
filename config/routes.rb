ActionController::Routing::Routes.draw do |map|

  map.resources :passwords, :controller => "user_passwords"

  map.signup "/signup", :controller => "users", :action => "create", :conditions => { :method => :post}
  map.signup "/signup", :controller => "users", :action => "new", :conditions => { :method => :get}
  map.activation "/users/activate/:token", :controller => "users", :action => "activate"
  map.resources :users do |user|
    user.delete_account "/destroy", :controller => "users", :action => "confirm_destroy", :conditions => { :method => :get }
    user.delete_account "/destroy", :controller => "users", :action => "destroy", :conditions => { :method => :post }
    user.export "/export", :controller => "users", :action => "confirm_export", :conditions => { :method => :get }
    user.export "/export", :controller => "users", :action => "export", :conditions => { :method => :post }
  end

  map.login "/login", :controller => "user_sessions", :action => "create", :conditions => { :method => :post}
  map.login "/login", :controller => "user_sessions", :action => "new", :conditions => { :method => :get}
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"

  map.create_categories_defaults "/categories/create_defaults", :controller => "categories", :action => "create_defaults"
  map.resources :categories do |category|
    category.connect "/:action", :controller => "categories", :action => "account"
  end

  map.create_accounts_defaults "/accounts/create_defaults", :controller => "accounts", :action => "create_defaults"
  map.resources :accounts do |accounts|
    accounts.resources :entries
  end
  map.entries_category_balance "/entries/category/:category_id/balance", :controller => "entries", :action => "category_balance"
  
  map.overview "/overview/:action", :controller => "overview", :action => "index"

  map.root :controller => "overview"

end
