class AnnouncementsController < ApplicationController
  layout 'empty'

  def index
  end

  def show
    @announcement = Announcement.find(params[:id])
    if request.xhr?
      render :text => @announcement.contents, :layout => false
    end
  end

  def showmore
    @announcement = Announcement.find(params[:id])
  end

end
