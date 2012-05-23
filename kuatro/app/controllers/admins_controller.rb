class AdminsController < ApplicationController
  layout 'admin'
  before_filter :authenticate, :except => [:index, :login, :logout]

  def index
    if logged_in?
      redirect_to dashboard_admins_path and return
    end
  end

  def add_letter
    if request.post?
      Letter.create(params[:letter])
      redirect_to letters_admins_path
    end
  end
  
  def edit_letter
    @letter = Letter.find(params[:id])
    if request.post?
      @letter.update_attributes(params[:letter])
      flash[:notice] = "Testimoney successfully updated."
      redirect_to letters_admins_path
    end
  end
  
  def delete_letter
    unless params[:id].nil?
      l = Letter.find(params[:id])
      l.destroy
      redirect_to letters_admins_path
    end
  end
  
  def letters
    @letters = Letter.order("created_at DESC")
  end

  def newcategory
    if request.post?
      unless params[:name].blank?
        Category.create(:name => params[:name])
        flash[:notice] = "You've got a new category. add an album now."
        redirect_to gallery_admins_path
      end
    end
  end
  
  def viewalbum
    @album = Album.find(params[:album_id])
  end
  
  def newalbum
    
    if request.post?
      a = Album.new
      a.category_id = nil
      a.name = params[:name]
      a.save!
      redirect_to gallery_admins_path
    end
  end
  
  def addpicture
    if request.post?
      if params[:picture][:image].nil?
        flash[:error] = "You forgot to select a photo."
        redirect_to gallery_admins_path(:album_id => params[:album_id]) and return
      end
      pic = Picture.create(params[:picture])
      pic.description
      pic.album_id = params[:album_id]
      pic.save!
      redirect_to gallery_admins_path(:album_id => params[:album_id])
    end
  end
  
  def gallery
    @albums = Album.order("created_at desc")
    
    unless params[:album_id].nil?
      @album = Album.find(params[:album_id])
    end
  end
      
  def featured
    @featured = FeaturedImage.order("created_at desc")
  end

  def delete_category
    c = Category.find(params[:cat_id])
    c.destroy
    redirect_to gallery_admins_path
  end

  def delete_album
    a = Album.find(params[:album_id])
    a.destroy
    redirect_to gallery_admins_path(:cat_id => params[:cat_id])
  end

  def delete_picture
    p = Picture.find(params[:picture_id])
    p.destroy
    redirect_to gallery_admins_path(:album_id => params[:album_id], :cat_id => params[:cat_id])
  end
    
  def delete_featured
    f = FeaturedImage.find(params[:id])
    f.destroy
    redirect_to featured_admins_path
  end
  
  def logout
    reset_session
    redirect_to admins_path and return
  end
  
  def login
    if request.post?
      u = User.find_by_email_and_password(params[:email], params[:password])
      unless u.nil?
        session[:user_id] = u.id
        redirect_to dashboard_admins_path
      else
        redirect_to admins_path
      end
    else
      redirect_to login_admins_path
    end
  end
  
  def dashboard
  end

  def feature
    if request.post?
      f = FeaturedImage.create(params[:featured_image])
      redirect_to featured_admins_path
    end
  end
end
