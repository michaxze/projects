class Business::OffersController < ApplicationController
  layout "business"
  before_filter :business_authenticate
  before_filter :business_top_checker

  def delete_images
    deal = current_user.deals.find(params[:id]) rescue nil
    unless deal.nil?
      unless params[:picture_ids].nil?
        picture_ids = params[:picture_ids].split(",")
        pictures = deal.pictures.where("id IN (?)", picture_ids)
        pictures.destroy_all
      end
    end

    redirect_to gallery_business_offer_path(deal)
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
    redirect_to gallery_business_offer_path(pic.pictureable)
  end

  def edit_picture
    @picture = Picture.find(params[:id])
    render :layout => false
  end

  def publish
    @deal = current_user.deals.find(params[:id])
    if !["location", "published"].include?(@deal.status)
      redirect_to myoffers_business_path and return
    end

    if @deal.ongoing?
      if @deal.start.to_date <= Time.now.to_date
        @deal.update_attribute(:status, 'published')
        unless params[:pub].blank?
          param = { :section => Constant::NEW_OFFER , :action_name => Constant::ADDED }
          ListingUpdate.create_new(current_user, @deal, param)
          broadcast("/account")
        end
      else
        @deal.update_attribute(:sort_status, "0a")
        @deal.update_attribute(:status, 'complete')
      end
    else
      if @deal.start.to_date <= Time.now.to_date && @deal.end.to_date >= Time.now.to_date
        @deal.update_attribute(:status, 'published')
        @deal.update_attribute(:sort_status, "1")

        unless params[:pub].blank?
          param = { :section => Constant::NEW_OFFER , :action_name => Constant::ADDED }
          ListingUpdate.create_new(current_user, @deal, param)
          broadcast("/account")
        end
      else
        @deal.update_attribute(:status, 'complete')
        @deal.update_attribute(:sort_status, "0a")
      end
    end

    @deal.update_attribute(:page_code, create_unique_code(@deal))
    @deal.reload.update_listing

    d = Deal.find(@deal.id)
    if d.status == "published"
      d.listing.update_attribute(:published_at, Time.now)
    end

    flash[:notice] = "Offer successfully published."
    redirect_to(myoffers_business_path) and return
  end

  def edit
    @deal = current_user.deals.find(params[:id])
    redirect_to myoffers_business_path if @deal.mystatus == "expired"
		@page_title = "Edit offer - "+@deal.name.titleize rescue ''
  end

  def upload_images
    if request.xhr? || request.post?
      deal = current_user.deals.find(params[:id])
      unless current_user.nil?
        begin
          if current_user.remaining_images(deal) > 0 || current_user.premium_subscriber?
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
            p.pictureable = deal
            p.user_id = current_user.id
            p.save

            File.delete(dest_file)

            if deal.is_published?
              param = { :section => Constant::NEW_IMAGES , :action_name => Constant::ADDED }
              ListingUpdate.create_new(current_user, deal, param)
              broadcast("/account")
            end


            html = render_to_string(:partial => "/business/offers/picture", :locals => { :picture => p })
            html = html.gsub("<", "&lt;")
            res = { :success => "true", :id => "#{p.id}", :filename => p.image.url(:thumb), :html => html, :remaining => current_user.remaining_images(deal)-1 }
          else
            res = { :success => "full", :remaining => current_user.remaining_images(deal), :html => ''}
          end

          render :text => res.to_json
        rescue Exception => e
puts e.message.inspect
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
    @deal = current_user.deals.find(params[:id])
  end
  
  def pricing
    @page_title = "Pricing"
    @deal = current_user.deals.find(params[:id])
  end
  
  def locations
    @page_title = "Location"
    @deal = current_user.deals.find(params[:id]) rescue nil
    @address = @deal.address
  end
  
  def index
    
  end
  
  def new
    @page_title = "Create an offer"
    @place = current_user.places.first
  end
  
  def create
    begin
      @deal = Deal.new(params[:deal])
      @deal.category_id = current_user.places.first.category_id
      @deal.place_id = current_user.places.first.id rescue nil
      @deal.status = "details"
      @deal.user_id = current_user.id
      @deal.start = params[:offer][:start] unless params[:offer][:start].nil?
      @deal.end = params[:offer][:end] unless params[:offer][:end].nil?
      @deal.ongoing = (params[:offer][:ongoing] == 'on' ? 1 : 0) unless params[:offer][:ongoing].nil?
      @deal.save!

      redirect_to locations_business_offer_path(@deal, :new => 1)
    rescue Exception => e
      flash[:error] = e.message.to_s
      render :action => :new
    end
  end

  def update
    @deal = current_user.deals.find(params[:id])
    cdeal = @deal.clone
    caddress = @deal.address.clone rescue nil
    begin
      if params[:steps] != "location"
        @deal.update_attributes!(params[:offer])
      end
      fix_urls(@deal)

      if @deal.is_published?
        if (cdeal.name != @deal.name || cdeal.description != @deal.description || cdeal.extra_info != @deal.extra_info || cdeal.tags || @deal.tags || cdeal.facebook != @deal.facebook || cdeal.twitter != @deal.twitter ) && !@deal.is_oneday?
          param = { :section => Constant::AN_OFFER , :action_name => Constant::UPDATED, :shown => false }
          ListingUpdate.create_new(current_user, @deal, param)
          broadcast("/account")
        end
      end

      case params[:steps]
      when "location"

        if params[:use_place_info] == "1"
          @deal.update_attribute(:use_place_info, true)
        else
          @deal.update_attributes!(params[:offer])
          @deal.update_attribute(:use_place_info, false)
        end

        if ["details", "location"].include?(@deal.status)
          @deal.update_attribute(:status, 'location')
        end
        @deal.update_attribute(:use_place_address, params[:use_place_address]) unless params[:use_place_address].nil?

        if @deal.save!
          unless params[:use_place_address].nil?
            if params[:use_place_address].to_s == "0"
              address = @deal.address || Address.create(params[:address])
              address.update_attributes!(params[:address]) if !address.new_record?
              address.addressable = @deal
              if address.save!
                address.update_attribute(:lat, params[:address_lat])  unless params[:address_lat].nil?
                address.update_attribute(:lng, params[:address_lng])  unless params[:address_lng].nil?

                unless caddress.nil?
                  if caddress.complete_address != address.complete_address
                    param = { :section => Constant::ADDRESS , :action_name => Constant::UPDATED }
                    ListingUpdate.create_new(current_user, @deal, param)
                    broadcast("/account")
                  end
                end
              end
            end
          end
        end
        
        redirect_to gallery_business_offer_path(@deal)
      when "pricing"
        @deal.update_attribute(:status, 'pricing') if @deal.status != "complete"
        @deal.start = params[:offer][:start_date] unless params[:offer][:start_date].nil?
        @deal.end = params[:offer][:end_date] unless params[:offer][:end_date].nil?
        @deal.ongoing = params[:offer][:ongoing] unless params[:offer][:ongoing].nil?
        @deal.save!
        
        @deal.update_attribute(:status, 'complete')
        
        
        redirect_to gallery_business_offer_path(@deal)
      else
        @deal.start = params[:offer][:start_date] unless params[:offer][:start_date].nil?
        @deal.end = params[:offer][:end_date] unless params[:offer][:end_date].nil?
        @deal.ongoing = (params[:offer][:ongoing] == 'on' ? 1 : 0)
        @deal.save!

        if ["complete", "published"].include?(@deal.status)
          @deal.update_attribute(:page_code, create_unique_code(@deal))
        end

        if @deal.status == "complete"
          if @deal.ongoing?
            if @deal.start.to_date <= Time.now.to_date
              @deal.update_attribute(:status, 'published')
              @deal.update_listing
            else
              @deal.update_attribute(:status, 'complete')
            end
          else
            if @deal.start.to_date <= Time.now.to_date && @deal.end.to_date >= Time.now.to_date
              @deal.update_attribute(:status, 'published')
              @deal.update_listing
            else
              @deal.update_attribute(:status, 'complete')
            end
          end
        end
        
        redirect_to locations_business_offer_path(@deal)
      end
    rescue Exception => e
      puts e.message.inspect
      flash[:error] = e.message.to_s
      redirect_to locations_business_offer_path(@deal)
    end
  end

  def destroy
  end

  def remove
    js_string = ""
    Deal.where("id IN (?) ", params[:ids].split(",")).destroy_all

    params[:ids].split(",").each do |id|
      js_string += "$('.offer_row_#{id}').fadeOut(function(){ $(this).remove()});"
    end
    render :js => js_string
  end
end
