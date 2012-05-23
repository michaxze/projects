class HistoriesController < ApplicationController
  layout "user_cms"
  before_filter :authenticate
  before_filter :get_new_post, :only => [:index, :category]
  before_filter :get_recommendations, :only => [:index, :category]
  before_filter :set_history_page_title, :only => [:index]

  def index
    case params[:f]
    when "week_ago"
      @histories = current_user.histories.two_weeks_ago.includes(:listing)
    when "month_ago"
      @histories = current_user.histories.month_ago.includes(:listing)
    else
      @histories = current_user.histories.recent.includes(:listing)
    end
  end

  private
    def set_history_page_title
      @history_page_title = case params[:f]
      when "weeks_ago"
        "Week Ago"
      when "month_ago"
        "Month Ago"
      else
        "Recent"
      end
    end

end
