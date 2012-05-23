module AuthenticationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) rescue nil
  end

  def authenticate
    if !logged_in?
      unless request.referer.nil?
        flash[:error] = "Please login to view the page."
      end
      redirect_to admins_path and return
    end
  end

  def logged_in?
    if current_user.nil?
      reset_session
      return false
    end
    session[:user_id]
  end

end
