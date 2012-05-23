class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:token, :monthly, :reports, :settime]

  def index
    title = "Daily Time Record"
    if current_user
      
    end
  end

  def monthly
    @month = Time.now
    @times = DailyTime.for_month(current_user, Time.now)
  end
  
  def settime
    if request.post?
      DailyTime.record_time(current_user, params[:timein], params[:timeout])
    end
    redirect_to root_url, :notice => "Time recorded."
  end
  
  def reports
  end
  
  def token
  end
end
