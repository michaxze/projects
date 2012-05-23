class Cms::UsersController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate
  respond_to :html, :json, :xml

  def search
  end

  def new
  end

  def check_username
    ret = User.is_unique?(params[:email])
    render :text => (ret ? "1" : "0")
  end

  def index
    case params[:tab]
    when "regular"
      @users = User.get_users("regular", params)
    when "advertiser"
      @users = User.get_users("advertiser", params)
    when "administrator"
      @users = User.get_users("administrator", params)
    when "normal_admin"
      @users = User.get_users("normal_admin", params)
    else
      @users = User.get_users("regular", params)
    end
    @all_users = User.all.group_by(&:user_type)
    respond_with(@users)
  end

  def update_listing
    @listing = Listing.find(params[:id])
    @listing.update_attributes(params[:listing])
    path = get_listing_path(@listing)
    flash[:notice] = "Changes saved"
    respond_with(@listing, :location => path)
  end

  def edit_listing
    @listing = Listing.find(params[:id])
    load_category_select
    respond_with(@listing)
  end

  def destroy_listing
    @listing = Listing.find(params[:id])
    path = get_listing_path(@listing)
    @listing.destroy if @listing
    respond_with(@listing, :location => path)
  end

  def edit
   @user = User.find(params[:id])
   respond_with(@user)
  end

  def toggle_status
    @user = User.find(params[:id])
    @user.update_attribute(:status, (@user.status? ? false : true))

    flash[:notice] = "User status successfully updated."
    redirect_to cms_users_path(:tab => @user.user_type)
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    type = @user.user_type

    flash[:notice] = "Listing successfully updated."
    respond_with(@user, :location => cms_users_path(:tab => @user.user_type))
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy unless @user.nil?

    flash[:notice] = "User successfully deleted."
    respond_with(@user)
  end

  def places
    @user = User.find(params[:id])
    @places = @user.places
  end

  def events
    @user = User.find(params[:id])
    @events = @user.events
  end

  def deals
    @user = User.find(params[:id])
    @deals = @user.deals
  end

  private

    def load_category_select
      @category_select = []
      Category.where("parent_id IS NULL").collect { |c| @category_select << [c.name.titleize, c.id] }
    end

    def get_listing_path(listing)
      path = case listing.listing_type.to_s
      when "place"
        places_cms_listing_path(listing.listable.user)
      when "event"
        events_cms_listing_path(listing.listable.user)
      when "deal"
        deals_cms_listing_path(listing.listable.user)
      else
        #default for now
        places_cms_listing_path(listing.listable.user)
      end
      path
    end

end
