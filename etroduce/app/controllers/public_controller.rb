class  PublicController < ApplicationController
  layout 'public'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :confirm_password

  def public_profile
    @user = User.find_by_username(params[:username]) rescue nil
    if @user.nil?
      redirect_to root_path
    end
  end

end