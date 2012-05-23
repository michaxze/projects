class Admin::AdvertisersController < ApplicationController
  layout 'admin_users'
  before_filter :admin_authenticate

  def confirm
    u = User.find(params[:id])
    u.update_attribute(:status, 1)
  end

  def businessdetails
    @user = User.find(params[:id])
    @place = @user.places.first
  end
  
  def eventdetails
    event = Event.find(params[:event_id])
    render :text => render_to_string(:partial => "eventdetails", :locals => { :event => event })
  end

  def dealdetails
    deal = Deal.find(params[:deal_id])
    render :text => render_to_string(:partial => "dealdetails", :locals => { :deal => deal })
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
    redirect_to myplace_business_path(:t => 'gallery')
  end  
  
  def index
    @users = User.advertisers
    @users_count = @users.length
  end
  
  def userdetails
    @user = User.find(params[:id])
  end
  
  def suspend
    if request.post?
      @user = User.find(params[:id])
      @user.status = 2
      @user.save!
      SuspendedAccount.create!(:user_id => @user.id, :reason_code => params[:stype], :created_by => current_user.id)
    end
    
    render :nothing => true
  end
end
