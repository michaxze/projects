module Admin::AdvertisersHelper
  
  def show_subscription_type(user)
    type = "Free"
    subscription = user.latest_subscription
    
    unless subscription.nil?
      type = case subscription.package_code
      when "basic_monthly", "basic_yearly"
        "Basic"
      when "premium_monthly", "premium_yearly"
        "Premium"
      else
        "Free"
      end
    end

    type
  end

  def show_user_category(user)
    html = ""

    unless user.places.first.nil?
      unless user.places.first.nil?

        unless user.places.first.category.nil?
          html += user.places.first.category.name.titleize
          unless user.places.first.category.parent.nil?
            html += "<br/>#{user.places.first.category.parent.name.titleize}" rescue ''
          end
        else
         html = ""
        end
     end
    end

    html
  end

  def show_user_contactinfo(user)
    html = ""
    html += "#{user.places.first.telephone_numbers}" rescue ''
    html += " #{user.places.first.mobile_numbers}" rescue ''
  end
end
