class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticationHelper
  helper_method :current_user, :logged_in?
  
end
