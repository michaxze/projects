class Business::EventsController < ApplicationController
  layout "business"
  before_filter :business_authenticate
  before_filter :business_top_checker
  before_filter :check_permission, :only => [:create, :edit, :locations, :gallery, :new]

  def delete_images
    event = current_user.events.find(params[:id]) rescue nil
    unless event.nil?
      unless params[:picture_ids].nil?
        picture_ids = params[:picture_ids].split(",")
        pictures = event.pictures.where("id IN (?)", picture_ids)
        pictures.destroy_all
      end
    end

    redirect_to gallery_business_event_path(event)
  end

  def publish
    @event = current_user.events.find(params[:id])
    @event.update_attribute(:status, 'published')
    @event.update_attribute(:sort_status, '1')
    @event.update_listing
    @event.update_attribute(:page_code, create_unique_code(@event))
    @event.reload
    @event.listing.reload
    @event.listing.update_attribute(:published_at, Time.now)

    param = { :section => Constant::NEW_EVENT , :action_name => Constant::ADDED }
    ListingUpdate.create_new(current_user, @event, param)
    broadcast("/account")

    flash[:notice] = "Event successfully published."
    redirect_to myevents_business_path and return
  end

  def upload_gallery
    pic = Picture.find(params[:id])

    unless pic.nil?
      pic.name = params[:title]
      pic.description = params[:description]
      pic.save!
    end
    if params[:upload_image]
      pic.image = params[:upload_image]
      pic.save!
    end
    flash[:notice] = "Photo successfully updated."
    redirect_to gallery_business_event_path(pic.pictureable)
  end

  def edit_picture
    @picture = Picture.find(params[:id])
    render :layout => false
  end

  def edit
    @event = current_user.events.find(params[:id])
		@page_title = "Edit event - "+@event.name.titleize rescue ''
    redirect_to myevents_business_path if @event.mystatus == "expired"
  end

  def upload_images
    if request.xhr? || request.post?
      event = current_user.events.find(params[:id])
      unless current_user.nil?
        begin
          if current_user.remaining_images(event) > 0 || current_user.premium_subscriber?

            if ie_browser?
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

            p = Picture.new(:image => f)
            p.pictureable = event
            p.user_id = current_user.id
            p.save

            File.delete(dest_file)
            if event.is_published?
              param = { :section => Constant::NEW_IMAGES , :action_name => Constant::ADDED }
              ListingUpdate.create_new(current_user, event, param)
              broadcast("/account")
            end

            html = render_to_string(:partial => "/business/events/picture", :locals => { :picture => p })
            html = html.gsub("<", "&lt;")
            res = { :success => "true", :id => p.id, :filename => p.image.url(:thumb), :html => html, :remaining => current_user.remaining_images(event)-1 }
          else
            res = { :success => "full", :remaining => current_user.remaining_images(event), :html => ''}
          end

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

  def gallery
    @page_title = "Gallery"
    @event = current_user.events.find(params[:id])
  end
  
  def pricing
    @event = current_user.events.find(params[:id])
  end
  
  def locations
    @page_title = "Location"
    @event = current_user.events.find(params[:id]) rescue nil
    @address = @event.address
  end
  
  def index
    
  end
  
  def new
    @page_title = "Create an event"
    @place = current_user.places.first
  end
  
  def create
    begin
      @event = Event.new(params[:event])
      @event.category_id = current_user.places.first.category_id
      @event.place_id = current_user.places.first.id rescue nil
      @event.status = "details"
      @event.user_id = current_user.id

      unless params[:eventType].nil?
        @event.event_type = params[:eventType]
        
        case params[:eventType].to_s
        when "1"
          @event.start_date = params[:event][:start_date] unless params[:event][:start_date].nil?
          @event.end_date = nil
        when "2"
          @event.start_date = params[:event][:start_date] unless params[:event][:start_date].nil?
          @event.end_date   = params[:event][:end_date] unless params[:event][:end_date].nil?
        when "3"
          @event.event_day  = params[:event_weekly] unless params[:event_weekly].nil?
        when "4"
          @event.event_day  = params[:event_monthly] unless params[:event_monthly].nil?
        end
      end

      @event.start_time = params[:event][:start_time] unless params[:event][:start_time].nil?
      @event.end_time   = params[:event][:end_time] unless params[:event][:end_time].nil?
      @event.pricing_type = params[:event_type] unless params[:event_type].nil?
      @event.from_price = params[:from_price] unless params[:from_price].nil?
      @event.to_price   = params[:to_price] unless params[:to_price].nil?
      @event.event_type = params[:eventType] unless params[:eventType].nil?
      @event.save!

      redirect_to locations_business_event_path(@event, :new => 1)
    rescue Exception => e
      flash[:error] = e.message.to_s
      render :action => :new
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    cevent = @event.clone
    caddress = @event.address.clone rescue nil

    begin
      if params[:steps] != "location"
        @event.update_attributes(params[:event])
      end

      @event.update_attribute(:pricing_type, params[:pricing_type]) unless params[:pricing_type].nil?
      @event.pricing_type = params[:pricing_type] unless params[:pricing_type].nil?
      @event.from_price = params[:from_price] unless params[:from_price].nil?
      @event.to_price = params[:to_price] unless params[:to_price].nil?
      @event.event_type = params[:eventType] unless params[:eventType].nil?
      fix_urls(@event)

      if @event.is_published?
        if (cevent.name != @event.name || cevent.description != @event.description || cevent.start_time != @event.start_time || cevent.tags != @event.tags || cevent.facebook != @event.facebook || cevent.twitter != @event.twitter) && !@event.is_oneday?
          param = { :section => Constant::AN_EVENT , :action_name => Constant::UPDATED, :shown => false }
          ListingUpdate.create_new(current_user, @event, param)
          broadcast("/account")
        end
      end


      case params[:steps]
      when "location"

        if params[:use_place_info] == "1"
          @event.use_place_info = true
        else
          @event.update_attributes(params[:event])
          @event.use_place_info = false
        end

        if ["details", "location"].include?(@event.status)
          @event.status = 'location'
        end
        @event.use_place_address = params[:use_place_address] unless params[:use_place_address].nil?

        if @event.save!
          unless params[:use_place_address].nil?
            if params[:use_place_address].to_s == "0"
              address = @event.address || Address.create(params[:address])
              address.addressable = @event
              if address.save!
                address.update_attribute(:lat, params[:address_lat])  unless params[:address_lat].nil?
                address.update_attribute(:lng, params[:address_lng])  unless params[:address_lng].nil?

                unless caddress.nil?
                  if caddress.complete_address != address.complete_address
                    param = { :section => Constant::ADDRESS , :action_name => Constant::UPDATED }
                    ListingUpdate.create_new(current_user, @event, param)
                    broadcast("/account")
                  end
                end
              end
            end
          end
        end

        @event.update_listing
        redirect_to gallery_business_event_path(@event)
      else
        @event.start_time = params[:event][:start_time] unless params[:event][:start_time].nil?
        @event.end_time   = params[:event][:end_time] unless params[:event][:end_time].nil?
        @event.pricing_type = params[:event][:pricing_type] unless params[:event][:pricing_type].nil?
        @event.from_price = params[:from_price] unless params[:from_price].nil?
        @event.to_price   = params[:to_price] unless params[:to_price].nil?
        @event.event_type = params[:eventType] unless params[:eventType].nil?

        if ["complete", "published"].include?(@event.status)
          @event.page_code = create_unique_code(@event)
        end
        
          unless params[:eventType].nil?
            @event.event_type = params[:eventType]
          
            case params[:eventType].to_s
            when "1"
              @event.start_date = params[:event][:start_date] unless params[:event][:start_date].nil?
              @event.end_date = nil
              @event.event_day = nil
            when "2"
              @event.start_date = params[:event][:start_date] unless params[:event][:start_date].nil?
              @event.end_date   = params[:event][:end_date] unless params[:event][:end_date].nil?
              @event.event_day = nil
            when "3"
              @event.event_day  = params[:event_weekly] unless params[:event_weekly].blank?
            when "4"
              @event.event_day  = params[:event_monthly] unless params[:event_monthly].blank?
            end
          end
        
        @event.save!
        @event.update_listing
        redirect_to locations_business_event_path(@event)
      end
    rescue Exception => e
      puts e.message.inspect
      flash[:error] = e.message.to_s
      redirect_to locations_business_event_path(@event)
    end
  end

  def destroy
  end

  def remove
    js_string = ""
    Event.where("id IN (?) ", params[:ids].split(",")).destroy_all

    params[:ids].split(",").each do |id|
      js_string += "$('.event_row_#{id}').fadeOut(function(){ $(this).remove()});"
    end
    render :js => js_string
  end

  def check_permission
    redirect_to business_path if current_user.is_freeaccount?
  end
end
