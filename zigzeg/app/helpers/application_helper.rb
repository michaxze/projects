module ApplicationHelper

  def compute_time(event)
    (Time.now + 1.days).strftime('%B %d, %Y 23:59:59')
  end

  def custom_description(upd)
    words = []
    case upd.updateable_type
    when "Shout"
      name = upd.updateable.shoutable.name rescue ""
    when "Deal", "Event"
      if upd.action_name == "expiring" || upd.action_name == "starting"
        name = upd.updateable.name
      else
        name = upd.updateable.place.name rescue ""
      end
    else
      name = upd.updateable.name rescue ""
    end

    words << truncate(name, :length => 20, :omission => "...")

    if upd.action_name == "expiring"
      words << "will expire in 2 days"
    elsif upd.action_name == "starting"
      words << "will start in 2 days"
    else
      words << "has"
      words << upd.action_name
      if upd.action_name == Constant::ADDED and [Constant::NEW_OFFER, Constant::NEW_EVENT].include?(upd.section)
        words << "a"
      end

      case upd.section
      when Constant::OPERATING_HOURS, Constant::COMPANY_NAME
        words << "its"
      end
      words << "<label>#{upd.section}</label>"
    end

    raw(words.join(" ") + ".")
  end

  def ziglist_description(update)
    case update.updateable_type
    when "Shout"
     post_name = update.updateable.shoutable.name
    when "Deal", "Event"
      if update.action_name == "expiring" || update.action_name == "starting"
        post_name =  update.updateable.name
      else
        post_name = update.updateable.place.name
      end
    else
      post_name = update.updateable.name
    end

    link_name = truncate(post_name, :length => 55, :omission => "...")

    if update.action_name == 'expiring' || update.action_name == "starting"
      link_name += " will expire in 2 days"
    else
      link_name += " has #{update.action_name} "
      link_name += " its" if [Constant::OPERATING_HOURS, Constant::COMPANY_NAME].include?(update.section)
      if update.action_name == Constant::ADDED and [Constant::NEW_OFFER, Constant::NEW_EVENT].include?(update.section)
        link_name += " a "
      end
      link_name += "<label> #{update.section.downcase} </label>"
    end

    raw(link_name)
  end

  def format_html(str)
    str.gsub!("\n", "<br/>");
    raw str
  end

  def set_business_class(user)
    subscription = user.latest_subscription rescue nil
    class_name = "freeType"
    
    unless subscription.nil?
      case subscription.package_code.to_s
      when "basic_monthly", "basic_yearly"
        class_name = "basicType"
      when "premium_monthly", "premium_yearly"
        class_name = "premiumType"
      else
        class_name = "freeType"
      end
    end
    
    class_name
  end
  
	def get_status_msg(type,from)
			status = type rescue nil
			listFrom = from rescue nil
			msg = ""
			unless listFrom.nil?
			if listFrom == 'event'
					unless status.nil?
						case status
						when "published"
							msg = "This event is now online"
						when "notlive","complete"
							msg = "This event is waiting to go online"
						when "expired"
							msg = "This event has expired"
						when "inc"
							msg = "This event is saved but incomplete. Click on the 'Edit' icon to complete this event for it to be displayed online."
						else
							msg = "This event has been deleted"
						end
					end
			else
					unless status.nil?
						case status
						when "published"
							msg = "This offer is now online"
						when "notlive","complete"
							msg = "This offer will go online"
						when "expired"
							msg = "This offer has expired"
						when "inc"
							msg = "This offer is saved but incomplete. Click on the 'Edit' icon to complete this offer for it to be displayed online."
						else
							msg = "This offer has been deleted"
						end
					end
			end
			end
			msg
	end
  
	def show_zigged_class(listing)
    return "" if current_user.nil?

    unless current_user.nil?
      return "zigged" if current_user.has_this_favorite?(listing)
    end
    
    ""
  end

  def show_user_type(user)
    utype = case user.user_type.to_s
    when "administrator"
      "Master Administrator"
    when "normal_admin"
      "Normal Administrator"
    when "regular"
      "Regular User"
    when "advertiser"
      "Business"
    end

    utype
  end

  def show_breadcrumbs(controller_name)
  end

  def formatted_params(params)
    url = ""
    params.keys.each do |key|
      if !["action", "controller"].include?(key.to_s)
        if (key == "category")
          url += "&#{key}=#{params[key].join(',')}"
        else
          url += "&#{key}=" + CGI::escape(params["#{key}"])
        end
      end
    end
    url
  end

  def show_highlight(highlight)
    image_tag("/images/features/general/#{highlight.highlight_category.image}", :title => highlight.highlight_category.name)
  end

  def show_highlight2(highlight)
    raw("<div class=\"featIcon\" style=\"background:url('/images/features/nb/general/#{highlight.image}')\" title=\""+highlight.name+"\">&nbsp;</div>")
  end

  def show_category_feature(highlight)
    raw("<div class=\"featIcon\" style=\"background:url('/images/features/nb/#{highlight.image}')\" title=\""+highlight.name+"\">&nbsp;</div>")
  end

  def show_loader(name)
    img = image_tag "loaderB.gif", :alt => "loading"
    html = raw "<span id='loader_#{name}' style='display:none'>#{img}</span>"
  end

  def show_profile_image(user, thumb_size="super_thumb")
    return '' if user.nil?

    if user.avatar.exists?
      image_tag user.avatar.url("super_thumb") rescue  "noprofile.jpg"
    else
      image_tag "noprofile.jpg"
    end
  end

  def date_inwords(date)
    distance_of_time_in_words(date.to_time, Time.now)
  end

  def formatted_date(date, format=nil)
    return "" if date.nil?
    fdate = case format
    when "dmyyyy"
      date.strftime("%d %b %Y")
    when "yyyymmdd"
      date.strftime("%Y/%m/%d")
    when "mmddyyyy"
      date.strftime("%m/%d/%Y")
    when "ddmmyy"
      date.strftime("%d/%m/%y")
    when "ddmmyyyy"
      date.strftime("%d/%m/%Y")
    when "ddmmyyyyhm"
      date.strftime("%d/%m/%Y %I:%M")
    when "hm"
      date.strftime("%I:%M%p")
    else
      date.strftime("%B %d, %Y")
    end
    return fdate
  end

  def show_page_title(params)
    title = case params[:tab]
    when "members"
      "Members"
    when "advertisers"
      "Advertisers"
    when "madmins"
      "Administrators"
    when "regular"
      "Regular User"
    when "admins"
      "Normal Administrator"
    else
      ""
    end
  end

  def get_missing_image(posting, img_size='')
    image_path = case posting.class.name
    when "Place"
      "/images/missing_place#{img_size}.gif"
    when "Event"
      "/images/missing_event#{img_size}.gif"
    when "Deal"
      "/images/missing_deal#{img_size}.gif"
    else
      "/images/missing_places#{img_size}.gif"
    end
    image_path
  end
	
	 def get_missing_image_pg(posting, img_size='')
    image_path = case posting
    when "Place"
      "/images/missing_place#{img_size}.gif"
    when "Event"
      "/images/missing_event#{img_size}.gif"
    when "Deal"
      "/images/missing_deal#{img_size}.gif"
    else
      "/images/missing_places#{img_size}.gif"
    end
    image_path
  end
	
	def get_missing_uimage(gender, img_size='')
    if gender == 'female'
			image_path = '/images/female_silhouette.png'
		else
			image_path = '/images/_silhouette.png'
		end	
    image_path
  end

end
