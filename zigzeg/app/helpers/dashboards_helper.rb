module DashboardsHelper

  def show_select_cities(address, cities)
    html = render(:partial => "select_cities", :locals => { :cities => cities, :address => address })
    html
  end

  def show_select_sections(address, sections)
    html = render(:partial => "select_sections", :locals => { :sections => sections, :address => address })
    html
  end

  def get_user_setting(setting, option)
    ret = false
    unless setting.nil?
      ret = setting["#{option}"].blank? ? false : true
    end
    ret
  end

end
