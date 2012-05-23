module MyopportunitiesHelper

  def show_opportunity_status(opp)
    case opp.status.to_i
    when 1
      text = "Approved"
      text_color = "green"
    when 2
      text = "Denied"
      text_color = "#9E2800"
    when 0
      text = "Pending for approval"
      text_color = "#FF4D79"
    end

    html = "<span style=\"font-size: 10px; padding-left: 4px; color: #{text_color}\">#{text}</span>"
  end
end
