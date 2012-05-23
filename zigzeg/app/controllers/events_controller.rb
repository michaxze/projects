class EventsController < ApplicationController
  layout 'events'
  after_filter :record_views, :only => [:show]
  before_filter :public_top_checker

  def index
  end

  def show
    @event= Event.find_by_page_code(params[:name])
    if @event.nil?
      redirect_to notfound_path(:type => "event", :name => params[:name]) and return
    end

    @listing = @event.listing
    @place = @event.place

    if @event.expired? || @event.is_deleted?
      unless current_user.nil?
        redirect_to root_url if current_user != @event.user
      else
        redirect_to notfound_path(:type => "event") and return
      end
    end
		@page_title = @listing.name rescue ''
		catName =   @listing.category.parent.name rescue ''
		subCatName =   @listing.category.name rescue ''
		tagName = @listing.listable.tags rescue ''
		@page_key = "ZIGZEG, City Information System, Directory, Events & Happenings, #{@page_title}, #{catName}, #{subCatName}, #{tagName}"
		@page_desc = @listing.listable.description rescue ''
  end

  def preview

    if params[:type] == "event"
      @post =  Event.find(params[:id])
      @place = @post.place
    else
      @post = Deal.find(params[:id])
      @place = @post.place
    end
    (redirect_to form_url(@post) and return) if @post.status == "published"
    render :layout => "preview"
  end

end
