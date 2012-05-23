class MapsController < ApplicationController
  layout 'maps'
  before_filter :public_top_checker

  def index
    unless params[:search].blank?
      params[:search] = params[:search].gsub("Search...", "")
    end

    @listings = []
    unless params[:type].nil?
       @listings << class_eval(params[:type].classify).find(params[:id]).listing rescue nil
			 @group_listings = @listings.group_by(&:listing_type)
			 @page_title  = 'MapView'
    else
      @listings = Listing.get(params[:page], params[:search], { :type => params[:type], :per_page => Constant::MAP_INITIAL_NUMBER, :categories => params[:category]})

       @total_listings = []
       for i in 1..@listings.total_pages
         @total_listings += @listings.page(i)
       end

       @group_listings = @total_listings.group_by(&:listing_type)
    end

    @listings.compact!

    if params[:search].nil?
      @page_title  = 'MapView'
    else
      @page_title  = params[:search]
    end
  end

  def load_more
    @listings = Listing.get(params[:page], params[:search], { :categories => params[:category], :type => params[:type], :per_page => (params[:per_page] rescue Constant::MAP_MORE_NUMBER)})
    grouped = @listings.group_by(&:listing_type)
    html = render_to_string( :partial => "listing_row", :collection => @listings, :as => :listing)

    res = { :listings => @listings,
            :htmlstring => html,
            :counter_all => @listings.length,
            :counter_places => (grouped['place'].length rescue 0),
            :counter_deals => (grouped['deal'].length rescue 0),
            :counter_events => (grouped['event'].length rescue 0)
          }
    render :text => res.to_json
  end

  def get_information
    @listing = Listing.find(params[:id])
    case params[:type]
    when "deal"
      render :partial => "deal_details", :layout => false
    when "event"
      render :partial => "event_details", :layout => false
    when "place"
      render :partial => "place_details", :layout => false
    when "road"
      render :partial => "road_details", :layout => false
    else
      render :partial => "building_details", :layout => false
    end
  end

end
