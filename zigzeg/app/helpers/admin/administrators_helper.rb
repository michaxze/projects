module Admin::AdministratorsHelper

  def show_access_checked(user, section)
    return nil if user.settings.nil?
    unless user.settings.nil?
      unless user.settings['access'].nil?
        return "checked" if user.settings['access'].include?(section) 
      end
    end
    nil
  end
end
