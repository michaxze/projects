# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticationHelper
  before_filter :check_user_cookies
  helper_method :current_user, :form_url, :has_updates?



  def broadcast(channel, &block)
puts "broadcasting..."
    require 'net/http'
    begin
      message = {:channel => channel, :data => 'update', :ext => {:auth_token => Yetting.faye_token}}
      uri = URI.parse("http://localhost:9292/faye")
      Net::HTTP.post_form(uri, :message => message.to_json)
    rescue Exception => e
      msg = e.message.to_s rescue "There was an error in faye server"
      Mailer.notify_admin("michaxze@gmail.com", msg, "ZIGZEG: Faye server is down").deliver
    end
  end

  def to_datetime(date)
    DateTime.civil(date.year, date.month, date.day, 00, 01, 01, Rational(8,24))
  end

  def check_completeness
    unless current_user.nil?
      if current_user.is_advertiser? &&  current_user.steps != "complete"
        (redirect_to welcome_path  and return) if current_user.steps == "welcome"
        redirect_to "/welcome/#{current_user.steps}" and return
      end
    end
  end

  def create_unique_code(post)
    code = Helper.clean_url(post.name)

    case post.class.name
    when "Deal"
      results = Deal.where("id <> ? AND  page_code=?", post.id, code)
      unless results.empty?
        num = code.strip
        code = "#{code}" + (num.to_i + 1).to_s
      end
    when "Event"
      results = Event.where("id <> ? AND page_code=?", post.id, code)
      unless results.empty?
        num = code.strip
        code = "#{code}" + (num.to_i + 1).to_s
      end
    when "Place"
      results = Place.where("id <> ? AND page_code=?", post.id, code)
      unless results.empty?
        num = code.strip
        code = "#{code}" + (num.to_i + 1).to_s
      end
    end

    code
  end

  def check_user_cookies
    unless cookies[:rememberme].nil?
      session[:user_id] = cookies[:rememberme] unless cookies[:rememberme].blank?
    end
  end

  def get_recommendations
    @recommendations = Listing.recommendations
    get_most_popular
  end

  def get_new_post
    @newpost = Listing.first(:order => "ranking, created_at DESC", :conditions => "status=1")
  end

  def get_most_popular
    @mostpopular = Listing.get_mostpopular
  end

  def form_url(object, params={})
    url = root_url

    if object.class.name == "Place"
      url += "#{object.page_code}"
    elsif object.class.name == "Announcement"
      url += "#{object.announceable.page_code}/announcements/#{object.id}"
    elsif object.class.name == "Event"
      url += "#{object.place.page_code}/events/#{object.page_code}"
    elsif object.class.name == "Deal"
      url += "#{object.place.page_code}/deals/#{object.page_code}"
    else
      if object.listable.class.name == "Event"
        url += "#{object.listable.place.page_code}/events/#{object.listable.page_code}"
      elsif object.listable.class.name == "Deal"
        url += "#{object.listable.place.page_code}/deals/#{object.listable.page_code}"
      elsif object.listable.class.name == "Place"
        url += "#{object.listable.page_code}"
      end
    end

    parray = []
    if params.length > 0
      params.keys.each do |k|
        parray << "#{k}=#{params[k]}"
      end
      url += "?" + parray.join(",")
    end

    url
  end

  def public_top_checker
    @unread_messages, @unread_updates = []
    unless current_user.nil?
      unless params[:lupt].nil?
        lu = ListingUpdate.find(params[:lupt])
        if lu.updateable_type == "Shout"
          place = lu.updateable.shoutable
        else
          place = lu.updateable.place
        end
        Readable.create_new(current_user, place, lu) unless current_user.nil?
      end
      @unread_messages = current_user.messages.unread
      @unread_updates = current_user.latest_updates(true, 100)
    end
  end

  def admin_updates_checker
    @unread_messages = current_user.messages.unread rescue []
    @pending_alerts = Alert.pending
  end

  def user_top_checker
    @unread_messages = current_user.messages.unread rescue []
    @unread_updates = current_user.latest_updates(true,100) rescue []

    unless current_user.nil?
      unless params[:lupt].nil?
        lu = ListingUpdate.find(params[:lupt])
        if lu.updateable_type == "Shout"
          place = lu.updateable.shoutable
        else
          place = lu.updateable.place
        end
        Readable.create_new(current_user, place, lu) unless current_user.nil?
      end
      @unread_messages = current_user.messages.unread
      @unread_updates = current_user.latest_updates(true, 100)
    end
  end

  def business_top_checker
    @unread_messages = current_user.messages.unread rescue []
    @unread_updates = current_user.latest_updates(true,100) rescue []

    unless current_user.nil?
      unless params[:lupt].nil?
        lu = ListingUpdate.find(params[:lupt])
        if lu.updateable_type == "Shout"
          place = lu.updateable.shoutable
        else
          place = lu.updateable.place
        end
        Readable.create_new(current_user, place, lu) unless current_user.nil?
      end
      @unread_messages = current_user.messages.unread
      @unread_updates = current_user.latest_updates(true, 100)
    end
  end

  def has_updates?(tab='home')
    case tab
    when "home"
      return false if @pending_alerts.nil?
      return false if @unread_messages.nil?
      return true unless @pending_alerts.empty?
      return true unless @unread_messages.empty?
    when "user"
      return false #TODO
    else
      false
    end
  end


    def fix_urls(obj)
      if [Deal, Event].include?(obj.class)
        unless obj.website.nil?
          if obj.website.start_with?("https://")
            #do nothing
          elsif obj.website.start_with?("http://")
            #do nothing
          else
            obj.update_attribute(:website, "http://#{obj.website}")
          end
        end

          fb_url = "#{obj.facebook.to_s}"
          if fb_url.start_with?("https://")
          elsif fb_url.start_with?("http://")
          else
            if fb_url.include?("facebook.com")
              obj.update_attribute(:facebook, "http://#{fb_url}")
            else
              obj.update_attribute(:facebook, "http://www.facebook.com/#{fb_url}")
            end
          end

          tw_url = "#{obj.twitter.to_s}"
          if tw_url.start_with?("https://")
            #do nothing
          elsif tw_url.start_with?("http://")
            #do nothing
          else
            if tw_url.include?("twitter.com")
              obj.update_attribute(:twitter, "http://#{obj.twitter}")
            else
              obj.update_attribute(:twitter, "http://www.twitter/#{obj.twitter}")
            end
          end

      end
      obj.save
    end

  def redirect_iflogin
    redirect_to root_url if current_user
  end

  private

    def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end
    helper_method :mobile_device?

    def ie_browser?
      ua = request.env['HTTP_USER_AGENT'].downcase
      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        return true
      else
        return false
      end
    end

    def escape_single_quotes(str)
      str.gsub(/'/, "\\\\'")
    end

    def password_changed_and_match?(params)
      return false if params[:password].blank?
      return (params[:password] == params[:password_confirm])
      false
    end

    def clean_settings(params)
      settings = {}
      params.keys.each do |p|
        if Constant::SETTINGS.include?(p)
          settings["#{p}"] = params[p]
        end
      end
      settings
    end

    def get_unread_messages(user)
      user.messages.unread
    end

    def record_views
      unless @listing.nil?
        unless current_user.nil?
          if current_user.id != @listing.user_id
            @listing.increment!(:views, 1)
            History.create_history(current_user, @listing) unless current_user.nil?
          else
            @listing.increment!(:views, 1)
          end
        else
          @listing.increment!(:views, 1)
          History.create_history(current_user, @listing) unless current_user.nil?
        end
      end
    end

end
