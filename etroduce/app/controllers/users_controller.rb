class  UsersController < ApplicationController
  layout 'login_manage'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate, :except => [ :profile]

  def create_list
    render :text => "okay"
  end
  
  def show
    @user = User.find(params[:id])
  end

  def details
    user = User.find(params[:id])
    str = render_to_string(:partial => "details", :locals => { :user => user})
    render :text => str
  end
  
  def profile
    @user = User.find_by_username(params[:username]) rescue nil
    if @user.nil?
      redirect_to root_path
    end
  end
  
  def settings
    @user = current_user
    if request.post?
      if params[:user][:username].blank?
        flash[:error] = "Username can't be blank."
      elsif params[:user][:email].blank?
        flash[:error] = "Email address can't be blank."
      elsif User.username_unique?(params[:user][:username], @user)
        flash[:error] = "Username already exists."
      elsif User.exists?(params[:user][:email], @user)
        flash[:error] = "Email already exists."
      else
        unless params[:password].blank?
          params[:user][:password] = params[:password]
        end
        @user.update_user(params[:user])
        flash[:notice] = "Account successfully updated."
      end
      
    end
  end

end