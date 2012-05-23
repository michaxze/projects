class Admin::MapsController < ApplicationController
  layout "maps"
  before_filter :authenticate

  def index
    @listings = Listing.where("status=1")
  end
end