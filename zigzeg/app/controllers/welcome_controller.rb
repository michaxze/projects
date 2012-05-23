class WelcomeController < ApplicationController
  layout 'welcome'
  before_filter :authenticate
  before_filter :check_ifdone
  require 'mime/types'

  def delete_images
    place = Place.find(params[:id]) rescue nil

    unless place.nil?
      unless params[:picture_ids].nil?
        picture_ids = params[:picture_ids].split(",")
        pictures = place.pictures.where("id IN (?)", picture_ids)
        pictures.destroy_all
      end
    end

    redirect_to gallery_page_welcome_path
  end

  def edit_picture
    @picture = Picture.find(params[:id])
    render :layout => false
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

            p = Picture.new(:image => f)
            p.pictureable = place
            p.user_id = current_user.id
            p.save


            File.delete(dest_file)
            html = render_to_string(:partial => "picture", :locals => { :picture => p })
            html = html.gsub("<", "&lt;")
            res = { :success => "true", :id => p.id, :filename => p.image.url(:thumb), :html => html, :remaining => current_user.place_remaining_images }
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

  def show_category_features
    category = Category.find(params[:id])
    place = current_user.places.first
    render :text => render_to_string(:partial => "/welcome/show_category_features", :locals => { :category => category, :place => place })
  end

  def show_sub_category
    sub_category = current_user.place.sub_category ? current_user.place.sub_category : nil
    cat = Category.find(params[:id])
    selected_category = Category.find(params[:selected_category_id]) rescue nil
    categories = Category.subcategories(cat)

    render :text => render_to_string(:partial => "/welcome/show_sub_category", :locals => { :categories => categories, :category => cat, :selected_category => selected_category, :sub_category => sub_category })
  end

  def index
  end

  def show
		@page_title = "Welcome to Zigzeg"
    redirect_to "/business" if current_user.steps == "published"
    @place = current_user.places.first rescue nil
  end

  def create_page
		@page_title = "Create your page"
    @place = current_user.places.first rescue nil
    current_user.update_attribute(:steps, "create_page")

    if request.post?
      begin
        current_user.update_attribute(:advert_company_name, params[:place][:name])
        place = current_user.places.first ||  Place.create(params[:place])
        place.user_id = current_user.id
        place.operation_hours =  params[:hours] unless params[:hours].blank?
        place.operation_times = {:times => params[:times]}
        

        if place.save!
          place.update_attribute(:page_code, create_unique_code(place))
          place.update_attributes!(params[:place])
          fix_urls(place)
          address = place.address || Address.create(params[:address])
          address.update_attributes!(params[:address]) if !address.new_record?
          address.addressable = place

          if address.save!
            address.lat = params[:address_lat] unless params[:address_lat].nil?
            address.lng = params[:address_lng] unless params[:address_lng].nil?
            address.map_address_id = params[:map_address_id] unless params[:map_address_id].nil?
            address.save!
          end

          #creating free payment
          Payment.free_account(current_user) if current_user.payments.empty?
          redirect_to category_page_welcome_url
        end
      rescue Exception => e
        puts e.message.inspect
      end
    end
  end
  def category_page
    @page_title = "Select your business category & features"
    @place = current_user.places.first rescue nil
    redirect_to welcome_url if @place.nil?
    current_user.update_attribute(:steps, "category_page")

    if request.post?
      @place.category_id = params[:categoryType] unless params[:categoryType].blank?

      unless params[:subCategoryType].blank?
        ids = params[:subCategoryType].strip.split(",")
        @place.sub_category =  ids.join(",")
      else
        @place.sub_category = nil
      end

      @place.category_features = params[:category_features]
      @place.tags = params[:place][:tags] unless params[:place][:tags].nil?
      @place.save

      unless params[:features].nil?
        @place.highlights.destroy_all
        params[:features].each do |feature|
          highlight = HighlightCategory.find_by_code(feature)
          Highlight.create!(:highlightable => @place, :highlight_category_id => highlight.id)
        end
      end

      redirect_to gallery_page_welcome_path
    end
  end
  def gallery_page
		@page_title = "Upload your images"	
    @place = current_user.places.first rescue nil
    redirect_to welcome_url if @place.nil?
    current_user.update_attribute(:steps, "gallery_page")
  end

  def complete
		@page_title = "And you're done! Welcome to ZIGZEG..."	
		@place = current_user.places.first rescue nil
    redirect_to create_page_welcome_path if @place.nil?

    if current_user.steps == "published"
      redirect_to account_path
      return
    end

    #moving all temporary images
    current_user.update_attribute(:steps, "complete")
    @place.update_attribute(:status, 1)
    profile_image = TempImage.get_profile(current_user)
    unless profile_image.nil?
      a = profile_image.assets.first
      unless a.nil?
        a.uploadable = @place
        a.save!
      end
    end

    gallery = TempImage.get_gallery(current_user)
    gallery.each do |tmpimage|
      pic = Picture.new
      pic.pictureable =  @place
      pic.name = tmpimage.title
      pic.picture_type = tmpimage.photo_type
      pic.image = tmpimage.assets.first.image
      pic.save!
    end

    @place.update_listing
    @place.reload
    @place.listing.reload
    @place.listing.update_attribute(:published_at, Time.now)
  end

  def update_gallery
    ti = TempImage.find(params[:ti_id])
    unless ti.nil?
      ti.title = params[:title]
      ti.description = params[:description]
      ti.section_type = 'gallery'
      ti.photo_type = params[:photo_type]
      ti.save!
    end
    render :nothing => true
  end

  def upload_gallery
    if request.xhr?
        begin
          if ie_browser?
          raise "File is too large. Maximum file size is 4MB" if params[:qqfile].size > Constant::MAX_FILESIZE
          end

          filename = "#{Time.now.to_i}-#{params[:qqfile]}"
          dest_file = "#{Rails.root.to_s}/public/uploads/#{filename}"
          newfile = File.open(dest_file, "wb")
          newfile.write(request.body.read)
          newfile.close

          f = File.open(dest_file, 'r')

          tf = TempImage.new
          tf.user_id = current_user.id
          tf.section_type = "profile"
          tf.user_id = current_user.id
          tf.save!

          asset = Asset.new
          asset.uploadable = tf
          asset.authorable = current_user
          asset.image = f
          asset.save!

          File.delete(dest_file)
          res = { :success => "true", :filename => asset.image.url(:thumb10070), :id => tf.id }
          render :text => res.to_json
        rescue Exception => e
          error = { :error => e.message.to_s }
          render :text => error.to_json, :layout => false
        end
    end
  end

  def upload_profile
    if request.xhr? || request.post?
        begin
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
							dest_file = "#{Rails.root.to_s}/public/uploads/#{filename}"
							newfile = File.open(dest_file, "wb")
							newfile.write(request.body.read)
							newfile.close
							f = File.open(dest_file, 'r')
            end
          
          tf = TempImage.new
          tf.user_id = current_user.id
          tf.section_type = "profile"
          tf.user_id = current_user.id
          tf.save!

          asset = Asset.new
          asset.uploadable = tf
          asset.authorable = current_user
          asset.image = f
          asset.save!

          File.delete(dest_file)
          res = { :success => "true", :filename => asset.image.url(:thumb) }
          render :text => res.to_json
        rescue Exception => e
          error = { :error =>  e.message.to_s }
          render :text => error.to_json, :layout => false
        end
    end
  end

  def load_select_subcategories
    html = "<option value=''>None</option>"
    c = Category.find(params[:cat_id]) rescue nil

    unless c.nil?
      c.subcategories.each do |cat|
        html += "<option value='#{cat.id}'>#{cat.name}</option>"
      end
    end
    render :text => html
  end

  def check_ifdone
    redirect_to root_url if current_user.is_regular?
    unless current_user.nil?
      if current_user.steps == "complete"
        redirect_to root_url
      end
    end
  end

end
