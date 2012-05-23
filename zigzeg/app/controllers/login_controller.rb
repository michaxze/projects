class LoginController < ApplicationController
  layout 'login'
  before_filter :redirect_iflogin

  def login
		@page_title = "Log-in"
  end

  def forgot
		@page_title = "Password reset"
  end

  def verify
		@page_title = "Account not validated"
		
    @conf = Confirmation.where("token = ? AND used=0",params[:token]).first
		if request.post?
      unless @conf.nil?
        if @conf.confirmable.status == 1
          flash[:notice] = "User already activated"
        else
          @conf.update_attribute(:used, 0)
          flash[:notice] = "Click on the link present within your email to validate your account to validate your account."

          unless @conf.confirmable.latest_subscription.nil?
            activation_link = confirm_url(:token => @conf.token)
            if @conf.confirmable.latest_subscription.package_code == "free"
              Mailer.registration_confirmation(@conf.confirmable, activation_link).deliver
            else
              Mailer.registration_confirmation_payment(@conf.confirmable, activation_link, payment).deliver
            end
          end
        end
      else
        flash[:notice] = "Invalid token provided."
      end
    end
  end

end
