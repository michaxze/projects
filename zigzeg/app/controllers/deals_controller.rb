class DealsController < ApplicationController
  layout 'events'
  after_filter :record_views, :only => [:show]
  before_filter :public_top_checker

  def index
  end

  def show
    @deal = Deal.find_by_page_code(params[:name])
    if @deal.nil?
      redirect_to notfound_path(:type => "deal", :name => params[:name]) and return
    end
    @listing = @deal.listing
    @place = @deal.place

    if @deal.expired? || @deal.is_deleted?
      unless current_user.nil?
        redirect_to root_url if current_user != @deal.user
      else
        redirect_to root_url
      end
    end
		
		@page_title = @listing.name rescue ''
		catName =   @listing.category.parent.name rescue ''
		subCatName =   @listing.category.name rescue ''
		tagName = @listing.listable.tags rescue ''
		@page_key = "ZIGZEG, City Information System, Directory, Offers & Deals, Discounts & Shopping, #{@page_title}, #{catName}, #{subCatName}, #{tagName}"
		@page_desc = @listing.listable.description rescue ''

  end
end

