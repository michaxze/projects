class AccountController < ApplicationController
  layout "user_cms"
  before_filter :authenticate
  before_filter :user_top_checker, :only => [ :index, :show, :ziglist, :settings ]

  after_filter :clear_flash_error

  def show_update_history
    updates = current_user.latest_updates(nil, 50)
    render :text => render_to_string(:partial => "/account/update_history", :locals => { :updates => updates })
  end

  def update_listing_notification
    updates = current_user.latest_updates(true,100)
    html = ""
    updates.take(6).each do |u|
      html += render_to_string(:partial => "/globals/update_row", :locals => { :upd => u })
    end
    ret = { :total => updates.length, :html => html }
    render :json => ret.to_json
  end

  def clear_flash_error
    flash.discard
  end

  def index
    redirect_to admin_path if current_user.is_admin?
  end

  def show
    @page_title = "Overview - "+current_user.name_or_email.titleize rescue ''
    @notification = Notification.random_row(current_user, cookies["notification_id"])
    unless @notification.nil?
      cookies["notification_id"] = { :value => @notification.id, :expires => 7.days.from_now.utc }
    end

    redirect_to admin_path if current_user.is_admin?
    redirect_to business_path if current_user.is_advertiser?
  end

  def remove_ziglist
    js_string = ""
    current_user.favorites.where("likeable_type='Listing' AND likeable_id IN (?)", params[:ids].split(",")).delete_all
    params[:ids].split(",").each do |id|
      js_string += "$('.myziglist_listing_#{id}').fadeOut(function(){ $(this).remove()});"
    end
    render :js => js_string
  end
  def ziglist
    @page_title = "My Ziglist - "+current_user.name_or_email.titleize rescue ''
    fav_listings = []
    current_user.favorites.each do |fav|
      fav_listings << fav.likeable
  end
    all_hash = fav_listings.group_by(&:listing_type)
    @places  = all_hash['place'] || []
    @events  = all_hash['event'] || []
    @deals   = all_hash['deal'] || []
  end
  def welcome
    redirect_to welcome_account_url unless current_user.is_active?
  end
  def change_password
    if request.post?
      begin
        current_user.update_attribute(:password, Helper.encrypt_password(params[:user][:password]))
        render :nothing => true
      rescue Exception => e
        hash = Hash.new
        error = e.message.to_s.gsub("Validation failed:","").split(",")
        error.each{ |er| hash["#{er.split(' ').first.downcase}".to_sym] = er }
        render :json => hash.to_json, :layout => false
      end
    end
  end

  def settings
    @page_title = "Profile & Settings - "+current_user.name_or_email.titleize rescue ''
    if request.post?
      begin
        current_user.update_attributes(params[:user])
        current_user.update_attribute(:settings, params[:settings]) unless params[:settings].nil?
          cookies["profile_updated_#{current_user.id}"] = { :value => current_user.id, :expires => 1.months.from_now.utc }
        render :nothing => true
      rescue Exception => e
        hash = Hash.new
        error = e.message.to_s.gsub("Validation failed:","").split(",")
        error.each{ |er| hash["#{er.split(' ').first.downcase}".to_sym] = er }
        render :json => hash.to_json, :layout => false
      end
    end
    preload_select_cities
    preload_select_sections(current_user.city) unless current_user.city.nil?
  end

  def upload_profile
    if request.xhr? || request.post?
      unless current_user.nil?
        begin

          if ie_browser?
              raise "File is too large. Maximum file size is 4MB" if params[:qqfile].size > Constant::MAX_FILESIZE
              filename = "#{Time.now.to_i}-#{params[:qqfile].original_filename}"
              dest_file = "#{RAILS_ROOT}/public/uploads/#{filename}"
              t = params[:qqfile].tempfile.open
              newfile = File.open(dest_file, "wb")
              newfile.write(t.read)
              newfile.close
              f = File.open(dest_file, 'r')
          else
            filename = "#{Time.now.to_i}-#{params[:qqfile]}"
            dest_file = "#{RAILS_ROOT}/public/uploads/#{filename}"
            newfile = File.open(dest_file, "wb")
            newfile.write(request.body.read)
            newfile.close
            f = File.open(dest_file, 'r')
          end

          current_user.avatar = f
          current_user.save!
          File.delete(dest_file)

          res = { :success => "true", :filename => current_user.avatar.url(:thumb), :html => '' }
          render :text => res.to_json
        rescue Exception => e
          error = { :error => e.message.to_s }
          render :text => error.to_json, :layout => false
        end
      end
    end
  end

  def load_select_cities
    if params[:id].blank?
      render :text => ""
    else
      state = State.find(params[:id])
      cities = []
      state.cities.each {|ct| cities << [ ct.name, ct.id ]}
      render :partial => "select_cities", :locals => { :cities => cities }
    end
  end

  def load_select_sections
    if params[:id].blank?
      render :text => ""
    else
      city = City.find(params[:id])
      sections = []
      city.sections.each {|ct| sections << [ ct.name, ct.id ]}
      render :partial => "/account/select_sections", :locals => { :sections => sections }
    end
  end

  private
    def preload_select_states
      @states = []
      State.all(:order => "name ASC").each  {|s| @states << [ s.name, s.id] }
      @states
    end

    def preload_select_cities
      @cities = []
      City.all.each { |ct| @cities << [ ct.name, ct.id ]}
      @cities
    end

    def preload_select_sections(city)
      @sections = []
      unless city.nil?
        city.sections.each { |sc| @sections << [ sc.name, sc.id ]}
      end
      @sections
    end

    def get_unread_posts
      @new_deals = Listing.get_unread_posts(current_user, 'deal', 15)
      @new_events = Listing.get_unread_posts(current_user, 'event', 15)
      @new_places = Listing.get_unread_posts(current_user, 'place', 15)
    end

  def handle_unverified_request
    content_mime_type = request.respond_to?(:content_mime_type) ? request.content_mime_type : request.content_type
    if content_mime_type && content_mime_type.verify_request?
      raise ActionController::InvalidAuthenticityToken
    else
      super
      cookies.delete 'user_credentials'
      @current_user_session = @current_user = nil
    end
  end

end
