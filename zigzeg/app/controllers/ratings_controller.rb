class RatingsController < ApplicationController
  before_filter :authenticate

  def index
  end

  def ratethis
    @listing = Listing.find(params[:listing_id])
    @listing.increment!(:total_rates)
    @rating = Rating.new
    @rating.value = params[:value]
    @rating.rateable = @listing
    @rating.user_id = current_user.id

    if @rating.save!
      ret = { :total_rates => @listing.total_rates, :status => 'success', :rating => @listing.rating }
      render :json => ret.to_json
    else
      render :json => ret.json
    end
  end
end

