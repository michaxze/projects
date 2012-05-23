class DashboardsController < ApplicationController
  layout "user_cms"
  before_filter :authenticate
  before_filter :get_new_post, :only => [:show]
  before_filter :get_recommendations, :only => [:show, :general, :personal, :picture, :education, :contact, :settings]
  after_filter :clear_flash_error

  def clear_flash_error
    flash.discard
  end

  def index
  end

  def show
#    get_unread_posts
#    get_most_popular
 #   get_favorites_related
    @unread_messages = current_user.messages.unread.count
  end

  def general
    @user = User.find(current_user.id)

    if request.post?
      @user.update_attributes(params[:user])
      @user.update_attribute(:password, Helper.encrypt_password(params[:password])) if password_changed_and_match?(params)
      flash[:notice] = "Successfully updated your information"
    end
  end

  def personal
    @user = User.find(current_user.id)

    if request.post?
      @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated your information"
    end
  end

  def picture
    @user = User.find(current_user.id)

    if request.post?
      @user.update_attributes(params[:user])
      flash[:notice] = "Successfully uploaded your profile picture"
    end
  end

  def education
    @user = User.find(current_user.id)

    if request.post?
      @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated your information"
    end
  end

  def contact
    @user = User.find(current_user.id)

    if request.post?
      @user.update_attributes(params[:user])
      unless @user.address.nil?
        @user.address.update_attributes(params[:address])
        flash[:notice] = "Successfully updated your information"
      else
        @user.address = Address.new(params[:address])
        @user.save!
        flash[:notice] = "Successfully updated your information"
      end
    end
    preload_select_states(@user.address)
    preload_select_cities(@user.address)
    preload_select_sections(@user.address)
  end

  def settings
    @user = User.find(current_user.id)
    if request.post?
      settings = clean_settings(params)
      @user.update_attribute(:settings, settings)
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
      render :partial => "select_sections", :locals => { :sections => sections }
    end
  end

  private
    def preload_select_states(address)
      @states = []
      State.all(:order => "name ASC").each  {|s| @states << [ s.name, s.id] }
      @states
    end

    def preload_select_cities(address)
      @cities = []
      unless address.nil?
        s = State.find(address.state_id)
        unless s.nil?
          s.cities.each { |ct| @cities << [ ct.name, ct.id ]}
        end
      end
      @cities
    end

    def preload_select_sections(address)
      @sections = []
      unless address.nil?
        c = City.find(address.city_id)
        unless c.nil?
          c.sections.each { |sc| @sections << [ sc.name, sc.id ]}
        end
      end
      @sections
    end

    def get_unread_posts
      @new_deals = Listing.get_unread_posts(current_user, 'deal', 15)
      @new_events = Listing.get_unread_posts(current_user, 'event', 15)
      @new_places = Listing.get_unread_posts(current_user, 'place', 15)
    end

    def get_favorites_related
      all = []
      current_user.favorites.each do |fav|
        places << fav.likeable.listable.place
      end

      events = Event.where("status=1 AND created_at > ?", Time.zone.now - 30.days)
      deals = Deal.where("status=1 AND created_at > ?", Time.zone.now - 30.days)
      event_ids = events.map(&:id)
      deal_ids = deals.map(&:id)
  #    Listing.find(:all, :conditions => ["listable_type='Event' AND listable_id IN (?)", event_ids

      @favorite_listings = Listing.find(listing_ids)

    end

end
