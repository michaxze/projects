class Cms::ListingsController < ApplicationController
  layout 'user_cms'
  before_filter :authenticate
  respond_to :html, :json, :xml

  def index
    @advertisers = User.get_users("advertiser")
  end

  def update
    @listing = Listing.find(params[:id])
    @listing.update_attributes(params[:listing])
    path = get_listing_path(@listing)
    flash[:notice] = "Changes saved"
    respond_with(@listing, :location => path)
  end

  def create
    @listing = Listing.new
    @listing.update_attributes(params[:listing])

    if @listing.save!
      path = get_listing_path(@listing)
      flash[:notice] == "Listing successfully added."
      respond_with(@listing, :location => cms_user_listing_path(@user))
    else
      render :action => :new
    end
  end

  def new
    @user = User.find(params[:user_id])
    load_category_select
  end

  def edit
    @listing = Listing.find(params[:id])
    load_category_select
    respond_with(@listing)
  end

  def destroy
    @listing = Listing.find(params[:id])
    path = get_listing_path(@listing)

    unless @listing.nil?
      @listing.destroy
      flash[:notice] = "Listing successfully deleted."
    end
    respond_with(@listing, :location => path)
  end

  private
    def load_category_select
      @category_select = []
      Category.where("parent_id IS NULL").collect { |c| @category_select << [c.name.titleize, c.id] }
    end

    def get_listing_path(listing)
      return root_path if listing.nil?

      path = case listing.listing_type.to_s
      when "place"
        places_cms_user_path(listing.listable.user)
      when "event"
        events_cms_user_path(listing.listable.user)
      when "deal"
        deals_cms_user_path(listing.listable.user)
      else
        #default for now
        places_cms_user_path(listing.listable.user)
      end
      path
    end
end
