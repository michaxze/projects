module AdminHelper

  def show_new_class(user)
    return "new" if (Time.now.year.to_i - user.created_at.year.to_i) == 0
    ""
  end

  def show_event_status(event)
    status = "pending"

    case event.class.name.to_s
    when "Event"
      unless event.nil?
        unless event.start_date.nil?
          if event.start_date >= Time.now.to_date
            status = "live"
          end
        end
      
        unless event.end_date.nil?
          if Time.now.to_date > event.end_date
            status = "expired"
          end
        end
      end
    when "Deal"
      unless event.nil?
        unless event.start.nil?
          if event.start >= Time.now.to_date
            status = "live"
          end
        end
      
        unless event.end.nil?
          if Time.now.to_date > event.end
            status = "expired"
          end
        end
      end      
    end
    status
  end
  
end
