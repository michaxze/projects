class  HomeController < ApplicationController
  layout 'global'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :confirm_password
  before_filter :redirect_if_loggedin, :except => [:pageviewer, :contactus, :activate_na]

  def index
    @opportunities = Opportunity.get_public(nil, params[:search_str], params[:page], 8, @country)
    @categories = Category.find(:all)

    unless params[:to].blank?
      message = params[:msg] ? params[:msg] : "Hi there! This a test message from my application :)"
      destination = params[:to]
      QUEUE.enqueue(SmsSender, destination, message)
    end
  end

  def public_profile
    @user = User.find_by_username(params[:username].first) rescue nil
  end

  def pageviewer
    case params[:p].to_s
    when "aboutus"
      render :partial => "home/aboutus"
    when "contactus"
      render :partial => "home/contactus"
    else 
      render :text => "Invalid link."
    end
  end
  
  def contactus
    if request.post?
      params[:message] = params[:message].gsub("\n", "<br/>")
      UserMailer.deliver_contactus('john@hcapnet.com', params)
      UserMailer.deliver_contactus('michael@cebudirectories.com', params)
      render :text => 'success'
    end
  end
  
  
  def signup
    if request.post?
      if params[:username].blank?
        render :text => "Username can't be blank."
      elsif User.username_unique?(params[:username])
        render :text => "Username already exists."
      elsif params[:email].blank?
        render :text => "Email address can't be blank."
      elsif User.exists?(params[:email])
        render :text => "Email already exists."
      elsif params[:password].blank?
        render :text => "Password can't be blank."
      else
        begin
          user = User.create_user(params)
          activation_link = activate_url(:token => user.registration_token, :email => user.email)
          UserMailer.deliver_registration_confirmation(user, activation_link)
          render :text => "success"
        rescue Exception => e
          render :text => e.message.to_s
        end
      end
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

  def activate_na
    @user = User.find_by_registration_token(params[:token])
    unless @user.nil?
      @user.verified_identity_at = Time.now
      @user.registration_token = nil
      @user.save
      session[:email] = @user.email
    end
  end

  def confirm
    @invitation = Invitation.find_by_token(params[:token])
    user = User.find_by_email(@invitation.email) rescue nil

    unless user.nil?
      @invitation.confirmed_at = Time.now.to_date
      @invitation.token = nil
      @invitation.save
      User.add_invitation_to_contact(@invitation.user, user)
      UserMailer.deliver_confirm_network_owner(@invitation)
      
      flash[:notice] = "You have successfully joined #{@invitation.user.fullname}'s network."
      redirect_to "/#{user.username}"
    end
    
    if @invitation.nil?
      flash[:error] = "Invalid link."
      redirect_to root_path      
    end
    
    if request.post?
      existing_user = User.find(@invitation.email) rescue nil
      unless existing_user.nil?
        flash[:error]  = "Email address already exist."
      else
        dup_username = User.find_by_username(params[:contact_username])
        if dup_username.nil?
          user = User.new
          user.email = @invitation.email
          user.firstname = params[:contact_firstname]
          user.lastname = params[:contact_lastname]
          user.username = params[:contact_username]
          user.zipcode = params[:contact_zipcode]
          user.expertise = params[:contact_expertise]
          user.verified_identity_at = Time.now.to_date
          user.password = Helper.encrypt_password(params[:contact_password], @invitation.email)
          user.save

          @invitation.confirmed_at = Time.now.to_date
          @invitation.token = nil
          @invitation.save

          User.add_invitation_to_contact(@invitation.user, user)
          UserMailer.deliver_confirm_network_owner(@invitation)
          
          session[:email] = user.email
        
          flash[:notice] = "You have successfully created your account with Etroduce.com"
          redirect_to root_path
        else
          flash[:error]  = "Username already exist! Please choose a different username."
        end
      end
    end
  end  
  
  private
  
  def redirect_if_loggedin
    if current_user
      redirect_to opportunities_path
    end
  end
end