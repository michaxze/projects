module AuthenticationHelper
  def current_user
    if defined?(@current_account)
      @current_account = User.find_by_email(session[:email])
    else
      @current_account = User.find_by_email(session[:email])
    end
  end
end
