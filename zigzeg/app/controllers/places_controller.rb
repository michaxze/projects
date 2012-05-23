class PlacesController < ApplicationController
  layout 'places'
  after_filter :record_views, :only => [:show]
  before_filter :business_top_checker

  def show
    @place = Place.find_by_page_code(params[:name])

    unless @place.nil?
      @latest = @place.latest
    else
      redirect_to notfound_path(:type => "place", :name => params[:name]) and return
    end

   if @place.nil?
      flash[:error] = "Business does not exists!"
      redirect_to(root_path, :status => :found) && return
    end
		@listing = @place.listing
		placeName = @listing.name rescue ''
		catName =   @listing.category.parent.name rescue ''
		subCatName =   @listing.category.name rescue ''
		tagName = @listing.listable.tags rescue ''
		@page_key = "ZIGZEG, City Information System, Directory, Places & Landmarks, #{placeName}, #{catName}, #{subCatName}, #{tagName}"
  end
	def edit_shout
		render :text => 'ricci'
	end
  def all_whatsnew
    @place = Place.find(params[:id])
    if @place.nil?
      render :nothing => true if @place.nil?
    else
      whatsnew = @place.latest[5..-1]
      html = render_to_string(:partial => "whatsnew", :collection => whatsnew, :locals => { :appended => 1 })
      render :text => html
    end
  end

  def index
  end

  def list_deals
    @place = Place.find_by_page_code(params[:name])
    redirect_to form_url(@place) and return
  end

  def list_events
    @place = Place.find_by_page_code(params[:name])
    redirect_to form_url(@place) and return
  end

  def more_pictures
    place = Place.find(params[:place_id])
    place.pictures.shift(4)
    @pictures = place.pictures
    render :partial => "picture", :collection => @pictures
  end

  def preview
    @place = Place.find(params[:id])
  end

end
