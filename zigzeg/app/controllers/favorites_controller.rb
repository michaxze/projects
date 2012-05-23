class FavoritesController < ApplicationController
  layout "user_cms"
  before_filter :authenticate
  before_filter :get_new_post, :only => [:index, :category]
  before_filter :get_recommendations, :only => [:index, :category]
  before_filter :set_favorites_page_title, :only => [:index, :category]

  def index
    @favorites = current_user.favorites.recent.includes(:listing)
  end

  def category
    ids = Favorite.select("listing_id").map(&:listing_id)
    @listings = Listing.find(ids)
  end

  private
    def set_favorites_page_title
      @favorites_page_title = case action_name
      when "index"
        "Recent"
      when "category"
        "By Category"
      else
        "Recent"
      end
    end


end
