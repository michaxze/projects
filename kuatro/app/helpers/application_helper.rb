module ApplicationHelper
  
  def check_active_link(action, action_type)
    current_action = action_name
    current_controller = controller_name

    classname = case action_type
    when "controller"
      "selected" if action == current_controller
    else
      "selected" if action == current_action
    end
    classname
  end
end
