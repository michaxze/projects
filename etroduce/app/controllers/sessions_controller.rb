class SessionsController < ApplicationController
  layout 'global'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :confirm_password

  def password_reset
    @success = nil
    @pr = PasswordRequest.find_by_email_and_token(params[:email], params[:token])
    
    unless @pr.nil?
      #password link valid only for 2 days
      if (@pr.created_at.to_date + 2) < Date.today()
        flash[:error] = "Password link has expired."
        redirect_to root_path && return
      end
    else
      flash[:error] = "Invalid password reset link."
      redirect_to root_path && return
    end
    
    if request.post?
      if (!params[:password].blank? && !params[:confirm_password].blank?) && params[:password] == params[:confirm_password]
        u = User.find_by_email(params[:email])
        u.update_attribute(:password, Helper.encrypt_password(params[:password], params[:email]))
        @success = true
        @pr.destroy
        session[:email] = u.email        
        flash[:notice] = "You have successfully updated your password."
        redirect_to myopportunities_path(:p => 'f')
      else
        flash[:error] = "Password can't be blank or do not match.";
      end
    end
    #flash.discard
  end
  
  def forgot_password
    @sent = nil
    if request.post?
      unless params[:email].blank?
        user = User.find_by_email(params[:email]) rescue nil
        unless user.nil?
          pr = PasswordRequest.create(:email => params[:email], :token => Helper.generate_token)
          link = password_reset_url(:email => params[:email], :token => pr.token)
          UserMailer.deliver_send_forgot_password(user, link)
          @sent = true
        else
          flash[:error] = "Email address you entered can't be found."
        end
      else
        flash[:error] = "Please enter your email address."
      end
    end
    flash.discard
  end
  

  def create
    @error = nil
    unless params[:ret_url].blank?
      session[:referer] = request.referer
      flash[:error] = "Please login to view the page."
    end
    
    if request.post?
      username_or_email = params[:username_or_email].strip    
      tmp_user = Helper.is_email(username_or_email) ? 
              User.find_by_email(username_or_email) : User.find_by_username(username_or_email)
      email = tmp_user ? tmp_user.email : nil
      password = Helper.encrypt_password(params[:password], email )

      @user = User.find_by_email_and_password(email, password)
      unless @user.nil?
        if @user.not_confirmed?
          flash[:error] ="Oops! account not activated."
        else
          session[:email] = @user.email
          unless session[:referer].blank?
            redirect_to session[:referer].to_s
            session[:referer] = nil
          else
            redirect_to opportunities_path
          end
        end
      else      
        flash[:error] = "Oops! wrong username and password combination."
      end
      flash.discard
    end
  end
  
  def facebook_login
    auth = request.env["omniauth.auth"]
    user = User.find_by_email(auth["user_info"]["email"]) || User.create_with_omniauth(auth)
    user.update_facebook_information(auth)
    session[:email] = user.email
    redirect_to root_url, :notice => "You are now signed in."
  end

  def index
    if logged_in?
      redirect_to dashboard_index_path
    end
  end

  def stop
    reset_session
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path
  end

  protected

  def reset_session
    session[:email] = nil
  end

end
