class Admin::UtilitiesController < ApplicationController
  layout nil
  before_filter :admin_authenticate

  def pull
    system("cd /opt/apps/zigzeg/ & git pull & rake db:migrate")
    render :text => "Pulling updates from git... <br/> Running database migrations... <br/>Done updating the site..."
  end
end
