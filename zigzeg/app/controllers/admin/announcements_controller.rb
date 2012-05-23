class Admin::AnnouncementsController < ApplicationController
  layout "admin"
  before_filter :admin_authenticate
  before_filter :admin_updates_checker

  def index
    @announcements = Announcement.get_announcements(params[:page])
  end

  def show
  end

  def create
    begin
      announcement = Announcement.new
      announcement.update_attributes(params[:announcement])
      unless params[:banner].nil?
        announcement.banner = params[:banner]
        announcement.save!
      end
      redirect_to admin_announcements_path
    rescue Exception => e
      flash[:error] = e.message.to_s
      redirect_to new_admin_announcements_path
    end
  end

  def remove_announcements
    js_string = ""
    unless params[:ids].blank?
      Announcement.where("id IN (?)", params[:ids].split(",")).destroy_all
      params[:ids].split(",").each do |id|
        js_string += "$('.announcement_row_#{id}').fadeOut(function(){ $(this).remove()});"
      end
    end
    render :js => js_string
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    announcement = Announcement.find(params[:id])
    params[:start_date] = params[:start_date].to_date unless params[:start_date].nil?
    params[:end_date] = params[:end_date].to_date unless params[:end_date].nil?
    announcement.update_attributes(params[:announcement])
    unless params[:banner].nil?
      announcement.banner = params[:banner]
      announcement.save!
    end

    redirect_to admin_announcements_path
  end

end
