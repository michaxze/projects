class IndexController < ApplicationController
  protect_from_forgery # See ActionController::RequestForgeryProtection for details 
  helper :all # include all helpers, all the time

  def index
    @featured = FeaturedImage.order("created_at DESC");
  end

  def contactus
    @page = Content.find_by_code("contactus")
    if request.post?
      puts "sending here"
      Mailer.send_contactus(params).deliver
      flash[:notice] = "Your message has been successfully sent."
      redirect_to contactus_path
    end
  end

  def about
    @page = Content.find_by_code("about")
  end

  def love_letters
    @letters = Letter.order("created_at DESC")
  end
  
  def packages
    @page = Content.find_by_code("packages")
  end
  
  def gallery
      @albums = Album.order("created_at DESC")
      unless params[:id].nil?
        @album = Album.find(params[:id])
      end

  end
  
end
