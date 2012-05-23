class AdminController < ApplicationController
  before_filter :admin_authenticate
  before_filter :admin_updates_checker

  def show
    @alerts = Alert.where("status = 'pending'")
    @alert_hash = @alerts.group_by(&:alert_type)
    @messages = current_user.messages.unread.count
  end

  def alerts
   type = params[:type].blank? ? nil : params[:type]
   @alerts = Alert.get_alerts(params[:page], type)
  end

  def alert_details
    alert = Alert.find(params[:id])
    render :partial => "alert_details", :locals => { :alert => alert }
  end

  def alert_done
    alert = Alert.find(params[:id])
    alert.update_attribute(:status, 'done')
    render :nothing => true
  end

  def system
    redirect_to admin_administrators_path
  end

  def load_select_subcategories
    html = "<option value=''>Show all sub-category</option>"
    c = Category.find(params[:cat_id]) rescue nil

    unless c.nil?
      c.subcategories.each do |cat|
        html += "<option value='#{cat.id}'>#{cat.name.titleize}</option>"
      end
    end
    render :text => html
  end
  
end
