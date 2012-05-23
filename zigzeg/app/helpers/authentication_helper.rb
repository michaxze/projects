module AuthenticationHelper
  def current_user
    @current_user ||= User.find_activated_id(session[:user_id])
  end

  def authenticate
    if !logged_in?
      unless request.referer.nil?
        flash[:error] = "Please login to view the page."
      end
      redirect_to login_url(:ref_url => request.url) and return
    end
  end

  def logged_in?
    session[:user_id]
    if current_user.nil?
      reset_session
      return false
    end
    session[:user_id]
  end

  def business_authenticate
    if !logged_in?
      if request.referer.nil?
        flash[:error] = "Please login to view the page."
      end
      redirect_to login_url(:ref_url => request.url) and return
    else
      if current_user.steps != "complete"
        redirect_to create_page_welcome_url
      else
        redirect_to account_url if current_user.is_regular?
      end
    end
    redirect_to login_url(:ref_url => request.url) unless current_user.is_advertiser?
  end
  def admin_authenticate
    if !logged_in?
      unless request.referer.nil?
        flash[:error] = "Please login to view the page."
      end
      redirect_to login_url(:ref_url => request.url) and return
    end

    redirect_to login_url(:ref_url => request.url) unless current_user.is_admin?
  end
end
