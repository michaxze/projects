class Admin::SystemController < ApplicationController
  layout "admin"
  before_filter :authenticate

  def index
  end

  def show
  end

  def section_lock
  end

  def premium_feature_settings
  end

  def system_templates
  end

  def global_settings
    @settings = GlobalSetting.all.group_by(&:code)
    
    if request.post?
      unless params[:settings].nil?
        params[:settings].keys.each do |k|
          s = GlobalSetting.find_by_code(k) rescue nil
          unless s.nil?
            s.update_attribute(:option_value, params[:settings][k])
          end
        end
      end
      
      redirect_to global_settings_admin_system_path
    end
    
  end

end
