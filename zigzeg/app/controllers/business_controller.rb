class BusinessController < ApplicationController
  layout 'business'
  before_filter :business_authenticate, 
    :except => [
      :upload_images_place, 
      :search_building, 
      :searchaddress, 
      :tag_suggestions, 
      :search_postcode, 
      :search_city, 
      :search_section, 
      :upload_gallery,
      :show_category_features,
      :show_sub_category,
      :search_state,
      :search_country,
      :search_state_autocomplete,
      :search_country_autocomplete
    ]

  before_filter :business_top_checker,
    :only => [
      :index,
      :show,
      :myplace,
      :myevents,
      :myoffers,
      :ziglist,
      :account,
      :settings
    ]

  require 'mime/types'

  def search_state
    c = Country.find_by_name("Malaysia")
    state = State.where("LOWER(name) like ? AND country_id=?", "%#{params[:s].to_s.downcase}%", c.id).first
    status = (state.nil?) ? "false" : "true"
    render :text => status
  end

  def update_category
    place = Place.find(params[:id])
    place.update_attributes(params[:place])
    place.category_id = params[:categoryType] unless params[:categoryType].blank?
    unless params[:subCategoryType].blank?
      ids = params[:subCategoryType].strip.split(",")
      place.sub_category =  ids.join(",")
    else
      place.sub_category = nil
    end
    place.category_features =  params[:category_features]
    place.save

    features_ids = place.highlights.map(&:highlight_category_id).sort.uniq
    unless params[:features].nil?
      place.highlights.destroy_all
      params[:features].each do |feature|
        highlight = HighlightCategory.find_by_code(feature)
        Highlight.create!(:highlightable => place, :highlight_category_id => highlight.id)
      end
    else
      place.highlights.destroy_all
    end

    new_features_ids = place.highlights.map(&:highlight_category_id).sort.uniq

    if new_features_ids != features_ids
      param = { :section => Constant::NEW_FEATURES , :action_name => Constant::ADDED }
      ListingUpdate.create_new(current_user, place, param)
      broadcast("/account")
    end

    publish(place.id)
    redirect_to myplace_business_path(:t => "location")
  end

  def show_category_features
    category = Category.find(params[:id])
    place = current_user.places.first
    render :text => render_to_string(:partial => "/business/show_category_features", :locals => { :category => category, :place => place })
  end

  def show_sub_category
    sub_category = current_user.place.sub_category ? current_user.place.sub_category : nil

    cat = Category.find(params[:id])
    selected_category = Category.find(params[:selected_category_id]) rescue nil
    categories = Category.subcategories(cat)

    render :text => render_to_string(:partial => "/business/show_sub_category", :locals => { :categories => categories, :category => cat, :sub_category => sub_category, :selected_category => selected_category })
  end

  def delete_images
    place = Place.find(params[:id]) rescue nil

    unless place.nil?
      unless params[:picture_ids].nil?
        picture_ids = params[:picture_ids].split(",")
        pictures = place.pictures.where("id IN (?)", picture_ids)
        pictures.destroy_all
      end
    end

    redirect_to myplace_business_path(:t => "gallery")
  end
  
  def account
		@place = current_user.places.first
		@page_title = "My Account - "+@place.name.titleize rescue ''
    @package = current_user.latest_subscription
  end

  
	def tag_suggestions
    tags_html = ""
    tags = []
    alltags = []

    unless params[:tag].blank?
      tags_found = case params[:type].to_s
      when "place"
        Place.search_tag(params[:tag], params)
      when "event"
        Event.search_tag(params[:tag], params)
      when "deal"
        Deal.search_tag(params[:tag], params)
      end
    
      tags_found.each do |t|
        tags_html += "<li>#{t.downcase}</li>" unless t.nil?
      end
    end
    
    render :text => tags_html
  end
  
  def edit_picture
    @picture = Picture.find(params[:id])
    render :layout => false
  end
  
  def upload_gallery
    pic = Picture.find(params[:id])

    unless pic.nil?
      pic.name = params[:title]
      pic.description = params[:description]
      pic.picture_type = params[:photo_type]
      pic.save!
    end
    if params[:upload_image]
      pic.image = params[:upload_image]
      pic.save!
    end

    unless params[:ret_url].nil?
      redirect_to params[:ret_url]
    else
      redirect_to myplace_business_path(:t => 'gallery')
    end
  end

  def show
    redirect_to create_page_welcome_url if current_user.places.first.nil?
    @unread_messages = current_user.messages.unread
    @notification = Notification.random_row(current_user, cookies["notification_id"])
    unless @notification.nil?
      cookies["notification_id"] = { :value => @notification.id, :expires => 7.days.from_now.utc }
    end

    @place = current_user.places.first
    @page_title = "Overview - "+@place.name.titleize rescue ''
  end

  def myoffers
    @place = current_user.places.first
    @page_title = "My Offers - "+ @place.name.titleize rescue ''
    @offers = current_user.deals.paginate :page => params[:page], :per_page => 10, :order => "sort_status ASC, created_at DESC"
  end

  def myevents
    redirect_to business_path if current_user.is_freeaccount?
		@place = current_user.places.first
    @page_title = "My Events - "+@place.name.titleize rescue ''
    @events = current_user.events.paginate :page => params[:page], :per_page => 10, :order => "sort_status ASC, created_at DESC"
  end

  def myplace
    @place = current_user.places.first
    @address = @place.address rescue nil
    @categories = Category.parent_categories
		@page_title = "My Place - "+@place.name.titleize rescue ''
    
    unless @place.category.nil?
      unless @place.category.parent.nil?
        @subcategories = Category.subcategories(@place.category.parent)
      else
        @subcategories = Category.subcategories(@place.category)
      end
    end
  end

  def update_place
    begin
      place = Place.find(params[:id])

      if Listings.is_name_unique(params[:place][:name], 'place', place.id)
        flash[:error] = "Company name already exists."
        redirect_to myplace_business_path(:name => params[:place][:name]) and return
      end

      prev_place = place.clone
      place.update_attributes(params[:place])
      place.update_attribute(:category_id, params[:subcategory_id]) unless params[:subcategory_id].blank?
      place.update_attribute(:operation_hours, params[:hours]) unless params[:hours].blank?
      place.update_attribute(:operation_times, { :times => params[:times]})

      if prev_place.name != place.name
        param = { :section => Constant::COMPANY_NAME , :action_name => Constant::CHANGED }
        ListingUpdate.create_new(current_user, place, param)
        broadcast("/account")
      end

      if place.operation_times != prev_place.operation_times
        param = { :section => Constant::OPERATING_HOURS , :action_name => Constant::UPDATED }
        ListingUpdate.create_new(current_user, place, param)
        broadcast("/account")
      end

      unless params[:profile_image].nil?
        place.assets.destroy_all
        asset = Asset.new
        asset.uploadable = place
        asset.authorable = current_user
        asset.image = params[:profile_image]
        asset.save!
      end

      current_user.update_attribute(:advert_company_name, params[:place][:name])
      publish(place.id) unless place.address.nil?
      flash[:notice] = "Successfully updated."
      redirect_to myplace_business_path(:t => 'category')
    rescue Exception => e
puts e.message.inspect
      flash[:error] = e.message.to_s
      render :action => :myplace
    end
  end

  def update_location
    place = Place.find(params[:id])
    old_address = place.address.clone
    place.update_attributes!(params[:place])

    address = place.address || Address.create(params[:address])
    address.addressable = place
    address.update_attributes(params[:address]) if !address.new_record?
    address.lat = params[:address_lat] unless params[:address_lat].blank?
    address.lng = params[:address_lng] unless params[:address_lng].blank?
    address.save!

    if old_address.building_name != address.building_name || old_address.address_lot_number != address.address_lot_number || old_address.street != address.street
      param = { :section => Constant::ADDRESS , :action_name => Constant::ANEW }
      ListingUpdate.create_new(current_user, place, param)
      broadcast("/account")
    end
    place.update_listing
    redirect_to myplace_business_path(:t => :gallery)
  end

  def update_profile_image
   @place = current_user.places.first
   @place.assets.destroy_all

   asset = Asset.new
   asset.uploadable = @place
   asset.authorable = current_user
   asset.image = params[:Filedata]
   asset.save!
  end

  def upload_images_place
    if request.xhr? || request.post?
      place = Place.find(params[:id])
      unless current_user.nil?
        begin
          if current_user.place_remaining_images  > 0 || current_user.premium_subscriber?
            if ie_browser?
              raise "File is too large. Maximum file size is 4MB" if params[:qqfile].size > Constant::MAX_FILESIZE
              filename = "#{Time.now.to_i}-#{params[:qqfile].original_filename}"
              dest_file = "#{RAILS_ROOT}/public/uploads/#{filename}"
              t = params[:qqfile].tempfile.open
              newfile = File.open(dest_file, "wb")
              newfile.write(t.read)
              newfile.close
              f = File.open(dest_file, 'r')
            else
              filename = "#{Time.now.to_i}-#{params[:qqfile]}"
              dest_file = "#{RAILS_ROOT}/public/uploads/#{filename}"
              newfile = File.open(dest_file, "wb")
              newfile.write(request.body.read)
              newfile.close
              f = File.open(dest_file, 'r')
            end

            param = { :section => Constant::NEW_IMAGES , :action_name => Constant::ADDED }
            ListingUpdate.create_new(current_user, place, param)
            broadcast("/account")

            p = Picture.new(:image => f)
            p.pictureable = place
            p.user_id = current_user.id
            p.save

            File.delete(dest_file)

            html = render_to_string(:partial => "picture", :locals => { :picture => p })
            html = html.gsub("<", "&lt;")
            res = { :success => "true", :id => "#{p.id}", :filename => p.image.url(:thumb), :html => html, :remaining => current_user.place_remaining_images }
          else
            res = { :success => "full", :remaining => current_user.place_remaining_images, :html => '' }
          end
          render :text => res.to_json
        rescue Exception => e
          error = { :error => e.message.to_s }
          render :text => error.to_json, :layout => false
        end
      end
    end
  end

  def search_building
    return_str = ""
    addresses = MapAddress.search_building(params[:q])

    addresses.each do |a|
      cols = []
      cols << a.id
      cols << (a.street rescue '')
      cols << (a.section.name.titleize rescue '')
      cols << (a.section.postalcode rescue '')
      cols << (a.city.name.titleize rescue '')
      cols << (a.state.name.titleize rescue '')
      cols << (a.country.name.titleize rescue '')
      
      return_str += "#{a.building_name}|#{cols.join('|')}\n"
    end
    render :text => return_str
  end

  def searchaddress
    return_str = ""
    addresses = MapAddress.search_address(params[:q])

    addresses.each do |a|
      cols = []
      cols << a.id
      cols << (a.street rescue '')
      cols << (a.section.name.titleize rescue '')
      cols << (a.section.postalcode rescue '')
      cols << (a.city.name.titleize rescue '')
      cols << (a.state.name.titleize rescue '')
      cols << (a.country.name.titleize rescue '')
      cols << (a.lat rescue '')
      cols << (a.lng rescue '')

      return_str += "#{a.street}, #{a.section.name}, #{a.section.postalcode} |#{cols.join('|')}\n"
    end
    render :text => return_str
  end

  def search_section
    return_str = ""
    sections = Section.search_section(params[:q])

    sections.each do |a|
      cols = []
      cols << (a.name rescue '')
      cols << (a.postalcode rescue '')
      cols << (a.city.name.titleize rescue '')
      cols << (a.city.state.name.titleize rescue '')
      cols << (a.city.state.country.name.titleize rescue '')      

      return_str += "#{a.name}, #{a.postalcode}, #{a.city.name}|#{cols.join('|')}\n"
    end
    render :text => return_str
  end

  def search_city
    return_str = ""
    cities = City.search_city(params[:q])

    cities.each do |a|
      cols = []
      cols << (a.name rescue '')
      cols << (a.state.name.titleize rescue '')
      cols << (a.state.country.name.titleize rescue '')

      return_str += "#{a.name}, #{a.state.name}, #{a.state.country.name} |#{cols.join('|')}\n"
    end
    render :text => return_str
  end

  def search_country_autocomplete
    return_str = ""
    states = Country.search_name(params[:q].to_s.downcase)

    states.each do |s|
      cols = []
      cols << (s.name.titleize rescue '')

      return_str += "#{s.name.titleize} |#{cols.join('|')}\n"
    end
    render :text => return_str
  end

  def search_state_autocomplete
    return_str = ""
    states = State.search_name(params[:q].to_s.downcase)

    states.each do |s|
      cols = []
      cols << (s.name.titleize rescue '')
      cols << (s.country.name.titleize rescue '')

      return_str += "#{s.name.titleize}, #{s.country.name.titleize} |#{cols.join('|')}\n"
    end
    render :text => return_str
  end

  def search_postcode
    return_str = ""
    sections = Section.search_postcode(params[:q])

    sections.each do |a|
      cols = []
      cols << (a.postalcode rescue '')
      cols << (a.city.name.titleize rescue '')
      cols << (a.city.state.name.titleize rescue '')
      cols << (a.city.state.country.name.titleize rescue '')

      return_str += "#{a.postalcode}, #{a.city.name}, #{a.city.state.name} #{a.city.state.country.name} |#{cols.join('|')}\n"
    end
    render :text => return_str
  end


  def ziglist
		@place = current_user.places.first
		@page_title = "My Ziglist - "+@place.name.titleize rescue ''
    fav_listings = []
    current_user.favorites.each do |fav|
      fav_listings << fav.likeable
    end

    all_hash = fav_listings.group_by(&:listing_type)
    @places  = all_hash['place'] || []
    @events  = all_hash['event'] || []
    @deals   = all_hash['deal'] || []
  end

  def settings
    @place = current_user.places.first
    @page_title = "Profile & Settings - "+@place.name.titleize rescue ''

    if request.post?
      begin
        current_user.update_attributes!(params[:user])
        current_user.update_attribute(:settings, params[:settings]) unless params[:settings].nil?

        unless params[:password].blank?
          if params[:password] == params[:password_confirmation]
            current_user.update_attribute(:password, Helper.encrypt_password(params[:password]))
          end
        end

        unless current_user.places.first.nil?
          current_user.places.first.update_attribute(:name, params[:user][:advert_company_name])
          current_user.places.first.update_listing
        end

        if current_user.first_login?
          cookies["profile_updated_#{current_user.id}"] = { :value => current_user.id, :expires => 1.months.from_now.utc }
        end
        render :nothing => true
      rescue Exception => e
        hash = Hash.new
        error = e.message.to_s.gsub("Validation failed:","").split(",")
        error.each{ |er| hash["#{er.split(' ').first.downcase}".to_sym] = er }
        render :json => hash.to_json, :layout => false
      end
    end
    preload_select_cities
    preload_select_sections(current_user.city) unless current_user.city.nil?
  end
  
  def change_password
    if request.post?
      begin
        current_user.update_attribute(:password, Helper.encrypt_password(params[:user][:password]))
        render :nothing => true
      rescue Exception => e
        hash = Hash.new
        error = e.message.to_s.gsub("Validation failed:","").split(",")
        error.each{ |er| hash["#{er.split(' ').first.downcase}".to_sym] = er }
        render :json => hash.to_json, :layout => false
      end
    end
  end

  def upload_profile
    if request.xhr?
      unless current_user.nil?
        begin
          filename = "#{Time.now.to_i}-#{params[:qqfile]}"
          dest_file = "#{RAILS_ROOT}/public/uploads/#{filename}"
          newfile = File.open(dest_file, "wb")
          newfile.write(request.body.read)
          newfile.close
          f = File.open(dest_file, 'r')
          current_user.avatar = f
          current_user.save!
          File.delete(dest_file)
          res = { :success => "true", :filename => current_user.avatar.url(:thumb) }
          render :text => res.to_json
        rescue Exception => e
          hash = Hash.new
          error = e.message.to_s.gsub("Validation failed:","").split(",")
          error.each{ |er| hash["#{er.split(' ').first.downcase}".to_sym] = er }
          render :json => hash.to_json, :layout => false
        end
      end
    end
  end

  def upload_company_profile
    if request.xhr? || request.post?
      unless current_user.nil?
        begin
          place = Place.find(params[:id])
          place.assets.destroy_all

          if ie_browser?
              raise "File is too large. Maximum file size is 4MB" if params[:qqfile].size > Constant::MAX_FILESIZE

              filename = "#{Time.now.to_i}-#{params[:qqfile].original_filename}"
              dest_file = "#{RAILS_ROOT}/public/uploads/#{filename}"
              t = params[:qqfile].tempfile.open
              newfile = File.open(dest_file, "wb")
              newfile.write(t.read)
              newfile.close
              f = File.open(dest_file, 'r')
          else
            filename = "#{Time.now.to_i}-#{params[:qqfile]}"
            dest_file = "#{RAILS_ROOT}/public/uploads/#{filename}"
            newfile = File.open(dest_file, "wb")
            newfile.write(request.body.read)
            newfile.close
            f = File.open(dest_file, 'r')
          end

          asset = Asset.new
          asset.uploadable = place
          asset.authorable = current_user
          asset.image = f
          asset.save!

          File.delete(dest_file)

          res = { :success => "true", :filename => asset.image.url(:thumb) }
          render :text => res.to_json
        rescue Exception => e
          error = { :error => e.message.to_s }
          render :text => error.to_json, :layout => false
        end
      end
    end
  end



  private

  def publish(place_id)
    place = Place.find(place_id)

    unless place.nil?
      place.update_attribute(:status, true)
      place.update_listing
    end
  end  
  
  def preload_select_cities
    @cities = []
    City.all.each { |ct| @cities << [ ct.name, ct.id ]}
    @cities
  end

  def preload_select_sections(city)
    @sections = []
    unless city.nil?
      city.sections.each { |sc| @sections << [ sc.name, sc.id ]}
    end
    @sections
  end

end
