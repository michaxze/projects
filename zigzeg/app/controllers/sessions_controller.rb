class SessionsController < ApplicationController
  layout 'clean'

  def check_session
    ret = logged_in? ? "true" : "false"
    render :text => ret
  end

  def confirm
    reset_session
    n = Confirmation.find_by_token(params[:token])

    unless n.nil?
      if !n.expired?
        n.confirmable.update_attribute(:status, 1)
        n.confirmable.update_attribute(:activated_at, Time.now)
        n.update_attribute(:used, 1)
        session[:user_id] = n.confirmable.id

        if n.confirmable.user_type == "advertiser"
          redirect_to welcome_url
        elsif n.confirmable.user_type == "regular"
          redirect_to settings_account_url
        else
          redirect_to admin_url
        end
      else
        flash[:error] = "Expired link"
        redirect_to root_path
      end
    else
      flash[:error] = "Invalid link"
      redirect_to root_path
    end
  end

  def signup
		@page_title = "Signup"
    begin
      if User.is_unique?(params[:user][:username])
        @user = User.create_update(params[:user])
        #confirmation = Confirmation.create_confirmation(@user, params[:user])
        #activation_link = confirm_url(:token => confirmation.token)
        #Mailer.registration_confirmation(@user, activation_link).deliver
        render :text => "success"
      else
        render :text => "Email address already in use.<br />Please use a different email."
      end
    rescue Exception => e
      render :text => e.message.to_s.gsub("Validation failed:","").split(",").join("<br/>")
    end
  end

  def activate
    @user = User.find_by_email_and_registration_token(params[:email], params[:token])
    unless @user.nil?
      @user.verified_identity_at = Time.now
      @user.registration_token = nil
      @user.save
      session[:email] = @user.email
    end
  end

  def password_reset
		@page_title = "Password Reset"
    @token = Confirmation.find_by_token(params[:token]) rescue nil
    redirect_to login_path if @token.nil?

    if request.post?
      if params[:password].blank? && params[:confirm_password].blank?
        flash[:error] = "Please enter your new password with at least six characters."
      elsif params[:password] != params[:confirm_password]
        flash[:error] = "Password do not match."
      else
        password_string = "#{params[:password].strip} - Th3 Ult1m4t3 F1ght3r"
        new_password = Digest::SHA256.hexdigest(password_string)
        
        @token.confirmable.update_attribute(:password, new_password)
        @token.update_attribute(:used, true)
        flash[:notice] = "Wetwheew! Your password has been changed!"
      end
    else
      if @token.nil?
        flash[:error] = "Password reset link is invalid."
        #redirect_to password_reset_path
      end
      unless @token.nil?
        if @token.expired?
          flash[:error] = "Link already expired or used."
          redirect_to password_reset_path
        end
      end
    end
  end

  def normal_forgot_password
	@page_title = "Forgot Password"
    if request.post?
    user = User.find_by_email(params[:email]) rescue nil

    unless user.nil?
      confirmation = Confirmation.create_confirmation(user, params)
      Resque.enqueue(PasswordReset, user.id, confirmation.id)
      flash[:notice] = "true"
      redirect_to forgot_url
    else
      flash[:error] = "The email address provided does not exists."
      redirect_to forgot_url
    end
  end
  end

  def forget_password
    if request.post?
      user = User.find_by_email(params[:email]) rescue nil

      unless user.nil?
        confirmation = Confirmation.create_confirmation(user, params)
	      Resque.enqueue(PasswordReset, user.id, confirmation.id)
	      render :text => "true"
      else
        render :text => "The email address provided does not exists."
      end
    end
  end

  def create
    unless params[:provider].nil?
      # business account integration
      auth = request.env["omniauth.auth"]

      if !current_user.has_social(params[:provider])
        Social.create_new(auth, current_user, params[:provider])
      else
        flash[:error] = "Already have an existing #{params[:provider]} integration"
      end
      redirect_to business_path
    else
      auth = request.env["omniauth.auth"]
      user = User.create_with_omniauth(auth)

      if user.user_type == "advertiser"
        flash[:error] = "Email address you use in your facebook is already used. Please use another email address."
        redirect_to signup_path(:error => "facebook") and return
      end

      reset_session
      session[:user_id] = user.id
      redirect_to root_path, :notice => "Signed in!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  def normal_login
    reset_session
    u = User.find_activated_user(params[:username], params[:password])

    unless u.nil?
      session[:user_id] = u.id
      u.update_attribute(:last_login, Time.now.to_date)
      Login.create_new(u.email, request.remote_ip)

      if u.status == 0
        redirect_to verify_path(:email => u.email) and return
      end

      unless params[:rememberme].nil?
        cookies[:rememberme] = { :value => u.id, :expires => 1.months.from_now.utc }
      end

      if u.user_type == "advertiser" && u.steps != "complete"
        if u.steps == "welcome"
          redirect_to welcome_path and return
        else
          redirect_to "/welcome/#{u.steps}" and return
        end
			elsif  u.user_type == "advertiser" && u.steps == "complete"
					redirect_to "/business/" and return
      end

      unless params[:ref_url].nil?
        redirect_to params[:ref_url] and return
      else
        redirect_to account_url and return
      end
    else
      flash[:error] = "Incorrect username and password."
      redirect_to login_url(:ref_url => params[:ref_url], :username => params[:username]) and return
    end
  end


  def login
    reset_session
    u = User.find_activated_user(params[:username], params[:password])
    unless u.nil?
      session[:user_id] = u.id
      u.update_attribute(:last_login, Time.now.to_date)
      Login.create_new(u.email, request.remote_ip)

      if u.status == 0
       conf = Confirmation.create_confirmation(u, {:email => u.email})
       render :text => "verify?token=#{conf.token}" and return
      end

      unless params[:rememberme].nil?
        cookies[:rememberme] = { :value => u.id, :expires => 1.months.from_now.utc }
      end

      if u.is_admin?
        render :text => account_url and return
      end

      if u.user_type == "advertiser" && u.steps != "complete"
        if u.steps == "welcome"
          render :text => welcome_path and return
        else
          render :text => "/welcome/#{u.steps}" and return
        end
			elsif u.user_type == "advertiser" && u.steps == "complete"
					if request.referrer == maps_url()
							render :text => "#{request.referrer}" and return
					else
							render :text => "/business" and return
					end
      else
        render :text => "#{request.referrer}" and return
      end
    else
      render :text => "error"
    end
  end

  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['user_hash'] rescue false)
      self.email = (extra['email'] rescue '')
    end
  end

  def logout
    session[:user_id] = nil
    cookies.delete(:rememberme)
    reset_session
    unless params[:ret_url].nil?
      redirect_to params[:ret_url]
    else
      redirect_to root_url, :notice => "Signed out!"
    end
  end
  
  protected

   def auth_hash
     request.env['omniauth.auth']
   end  
end
