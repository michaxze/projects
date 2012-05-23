class  AccountsController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate, :except => [ :updateinfo ]

  def updateinfo
    user = User.find(params[:id])
    unless user.nil?
      user.update_user(params)
      session[:email] = user.email
      flash[:notice] = "You have successfully updated your account."
      redirect_to settings_path
    else
      flash[:error] = "User does not exist."
      redirect_to root_path
    end
  end
  
  def index
    redirect_to myopportunities_path(:p => 'f')
  end
end