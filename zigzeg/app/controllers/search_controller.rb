class SearchController < ApplicationController

  def index
    if !params[:q].blank? &&  params[:page].nil?
      Log.create("search", request, current_user, params)
    end
  end
end
