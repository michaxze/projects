class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticationHelper

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  helper_method :current_user, :logged_in?, :admin?
  
  before_filter :check_new_messages, :check_new_friend_requests, :detect_subdomain

  def current_cart
    if session[:cart_id]
      @current_cart ||= Cart.find(session[:cart_id])
      session[:cart_id] = nil if @current_cart.purchased_at
    end
    if session[:cart_id].nil?
      @current_cart = Cart.create!
      session[:cart_id] = @current_cart.id
    end
    @current_cart
  end

  protected

  def current_country_code
    @current_country_code = 'US' # set US as default
    g = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip) rescue nil

    unless g.nil?
      @current_country_code = case g.country_code.to_s
      when "US"
        g.country_code.to_s
      else
        nil #"US"
      end
    end
    session[:country_code] = @current_country_code
  end

  def detect_subdomain
    unless current_subdomain.nil?
      @subdomain = Subdomain.find_by_name(current_subdomain) rescue nil
      if @subdomain.nil?
        session[:sub_domain] = Subdomain.find_by_name("portland").name

        if RAILS_ENV == "development"
          redirect_to "http://lvh.me:30401"
        else
          if !%w(www a).include?(current_subdomain)
           redirect_to "http://a.etroduce.com"
          end
        end
      else
        session[:sub_domain] ||= @subdomain.name
      end
    end
    set_country(session[:sub_domain])
  end
  
  def set_country(subdomain)
    subdomain = "portland" if subdomain.nil?

    subdomain = subdomain.downcase
    if subdomain == "portland"
      @country = "US"
    elsif subdomain == "cebu"
      @country = "PH"
    elsif subdomain == "korea"
      @country = "KR"
    else
      @country = "US"
    end
    puts @country.inspect
  end
  
  def check_new_messages
    @new_messages  = []
    unless current_user.nil?
      @new_messages = Message.count_newmessages(current_user)
    end
  end
  
  def check_new_friend_requests
    @new_friend_requests = []
    unless current_user.nil?
      @new_friend_requests = Invitation.count_newinvites(current_user)
    end
  end

  def logged_in?
   session[:email]
  end

  def authenticate
    if !logged_in?
      unless request.referer.nil?
        flash[:error] = "Please login view the page."
      end
      redirect_to login_path(:ret_url => 1)
    end
  end
  
  def admin?(user)
    ["michaxze@gmail.com", "john@hcapnet.com"].include?(user.email)
  end

  def authenticate_admin
    if !logged_in? || !admin?(current_user)
      redirect_to root_path
    end
    
  end

  def current_cart
   if session[:cart_id]
     @current_cart ||= Cart.find(session[:cart_id])
     session[:cart_id] = nil if @current_cart.purchased_at
   end
   if session[:cart_id].nil?
     @current_cart = Cart.create!
     session[:cart_id] = @current_cart.id
   end
   @current_cart
 end
  
end
